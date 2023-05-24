//
//  SpotifyClient.swift
//  
//
//  Created by Julian Pomper on 18.05.23.
//

import Vapor

struct SpotifyClient {
    private let client: Client

    public init(client: Client) {
        self.client = client
    }
}

extension SpotifyClient {
    enum TokenError: LocalizedError {
        case getToken
        case profile
    }

    enum AuthType {
        case request(request: Request)
        case userId(String)
    }

    private var baseURL: URL {
        URL(string: "https://api.spotify.com/")!
    }

    @discardableResult
    public func saveToken(
        body: any Content,
        application: Application
    ) async throws -> String {
        let tokenHttpResponse = try await client.post("https://accounts.spotify.com/api/token") { request in
            try request.content.encode(
                body,
                as: .urlEncodedForm
            )
            request.headers.basicAuthorization = .init(
                username: Environment.get("BTR_CLIENT_ID")!,
                password: Environment.get("BTR_CLIENT_SECRET")!
            )
        }
        guard tokenHttpResponse.status.code == 200 else {
            throw TokenError.getToken
        }

        let tokenResponse = try tokenHttpResponse.content.decode(TokenRequestResponse.self)


        let profileHttpResponse = try await client.get(
            "https://api.spotify.com/v1/me"
        ) { request in
            request.headers.bearerAuthorization = .init(token: tokenResponse.accessToken)
        }

        guard profileHttpResponse.status.code == 200 else {
            throw TokenError.profile
        }

        let profileResponse = try profileHttpResponse.content.decode(UserProfileData.self)

        let user = try await User.find(profileResponse.id, on: application.db) ?? User()
        user.id = profileResponse.id
        user.name = profileResponse.displayName
        user.imageUrl = profileResponse.imageUrl
        user.uri = profileResponse.uri
        user.token = tokenResponse.accessToken
        if let refreshToken = tokenResponse.refreshToken {
            user.refreshToken = refreshToken
        }

        try await user.save(on: application.db)

        let token: UserToken
        if let existingToken = try await UserToken.query(on: application.db)
            .filter(\.$user.$id, .equal, profileResponse.id)
            .first() {

            token = existingToken

        } else {
            token = try user.generateToken()
            try await token.save(on: application.db)
        }

        return token.value
    }

    public func get(
        _ path: String,
        headers: HTTPHeaders = [:],
        application: Application,
        auth: AuthType,
        beforeSend: (inout ClientRequest) throws -> () = { _ in }
    ) async throws -> ClientResponse {
        try await send(.GET, headers: headers, to: path, application: application, auth: auth, beforeSend: beforeSend)
    }

    public func post(
        _ path: String,
        headers: HTTPHeaders = [:],
        application: Application,
        auth: AuthType,
        beforeSend: (inout ClientRequest) throws -> () = { _ in }
    ) async throws -> ClientResponse {
        try await send(.POST, headers: headers, to: path, application: application, auth: auth, beforeSend: beforeSend)
    }

    public func put(
        _ path: String,
        headers: HTTPHeaders = [:],
        application: Application,
        auth: AuthType,
        beforeSend: (inout ClientRequest) throws -> () = { _ in }
    ) async throws -> ClientResponse {
        try await send(.PUT, headers: headers, to: path, application: application, auth: auth, beforeSend: beforeSend)
    }

    public func delete(
        _ path: String,
        headers: HTTPHeaders = [:],
        application: Application,
        auth: AuthType,
        beforeSend: (inout ClientRequest) throws -> () = { _ in }
    ) async throws -> ClientResponse {
        try await send(.DELETE, headers: headers, to: path, application: application, auth: auth, beforeSend: beforeSend)
    }

    public func send(
        _ method: HTTPMethod,
        headers: HTTPHeaders = [:],
        to path: String,
        application: Application,
        auth: AuthType,
        isRetry: Bool = false,
        beforeSend: (inout ClientRequest) throws -> () = { _ in }
    ) async throws -> ClientResponse {
        var url = baseURL
        url.appendPathComponent(path)

        var mutableHeaders = headers
        let userToken: String?
        let refreshToken: String?
        switch auth {
        case let .request(request: request):
            let userId = try? request.auth.require(User.self).id
            let user = try? await User.find(userId, on: application.db)
            userToken = user?.token
            refreshToken = user?.refreshToken

        case let .userId(userID):
            let user = try? await User.find(userID, on: application.db)
            userToken = user?.token
            refreshToken = user?.refreshToken
        }

        if let userToken {
            mutableHeaders.bearerAuthorization = .init(token: userToken)
        }

        var response = try await client.send(
            method,
            headers: mutableHeaders,
            to: URI(string: url.absoluteString),
            beforeSend: beforeSend
        )

        guard (200...300).contains(response.status.code) else {
            application.logger.info("Failed with response status \(response.status.code)")
            if !isRetry && response.status == .unauthorized,
               let refreshToken {
                do {
                    try await saveToken(
                        body: TokenRefreshRequestBody(refreshToken: refreshToken),
                        application: application
                    )
                } catch {
                    if let tokenError = error as? TokenError, tokenError == .getToken {
                        logout(auth: auth)

                        response.headers.setCookie = HTTPCookies()
                        response.headers.setCookie?.all["token"] = .init(string: "", expires: .distantPast, domain: Environment.get("BTR_HOST")!, isSecure: true)
                    }
                    throw error
                }

                return try await send(
                    method,
                    headers: headers,
                    to: path,
                    application: application,
                    auth: auth,
                    isRetry: true,
                    beforeSend: beforeSend
                )
            } else {
                if response.status == .unauthorized {
                    logout(auth: auth)
                    response.headers.setCookie = HTTPCookies()
                    response.headers.setCookie?.all["token"] = .init(string: "", expires: .distantPast, domain: Environment.get("BTR_HOST")!, isSecure: true)
                }
                throw Abort(response.status)
            }
        }

        return response
    }

    private func logout(auth: AuthType) {
        if case let .request(request) = auth {
            request.auth.logout(User.self)
        }
    }
}

extension Request {
    var spotifyClient: SpotifyClient {
        .init(client: self.client)
    }
}

extension Application {
    var spotifyClient: SpotifyClient {
        .init(client: client)
    }
}

struct TokenRefreshRequestBody: Content {
    let grantType: String = "refresh_token"
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case refreshToken = "refresh_token"
    }
}

