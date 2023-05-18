//
//  File.swift
//  
//
//  Created by Max Gierlachowski (Private) on 13.05.23.
//

import Vapor

struct CallbackController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.grouped("callback").get(use: index)
    }
    
    func index(req: Request) async throws -> Response {
        let queryParams = try req.query.decode(CallbackQueryParams.self)
        
        let token = try await req.spotifyClient.saveToken(
            body: TokenRequestBody(code: queryParams.code),
            application: req.application
        )

        let response = req.redirect(to: "\(Environment.get("BTR_FRONTEND_DOMAIN")!)/home")
        response.cookies.all["token"] = .init(string: token, domain: Environment.get("BTR_FRONTEND_DOMAIN")!, isSecure: true)

        return response
    }
}

struct UserProfileData: Content {
    struct Image: Codable {
        let url: String
        let height: Int?
        let width: Int?
    }

    let displayName: String
    let href: String
    let id: String
    let images: [Image]
    let type: String
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case href
        case id
        case images
        case type
        case uri
    }
    
    var imageUrl: String {
        return images.first?.url ?? ""
    }
}

struct TokenRequestResponse: Content {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
    }
}

struct CallbackQueryParams: Decodable {
    let code: String
}

struct TokenRequestBody: Content {
    let grantType: String = "authorization_code"
    let code: String
    let redirectUri: String = "\(Environment.get("BTR_DOMAIN")!)/callback"
    
    enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case code
        case redirectUri = "redirect_uri"
    }
}
