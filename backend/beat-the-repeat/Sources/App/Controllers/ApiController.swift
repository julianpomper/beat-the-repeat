//
//  ApiController.swift
//  
//
//  Created by Julian Pomper on 13.05.23.
//

import Vapor

struct ApiController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("me") { me in
            me.get(use: getCurrentUser)
            me.put(use: updateCurrentUser)
        }

        routes.group("playlists") { playlists in
            playlists.get(use: getPlaylists)
        }
    }

    private func getCurrentUser(request: Request) async throws -> User.ApiUser {
        try User.ApiUser(user: request.auth.require(User.self))
    }

    private func updateCurrentUser(request: Request) async throws -> User.ApiUser {
        let user = try request.auth.require(User.self)
        let updateRequest = try request.content.decode(UpdateUserRequest.self)

        user.selectedPlaylistID = updateRequest.selectedPlaylistID
        user.isActive = updateRequest.isActive

        try await user.save(on: request.db)
        return try User.ApiUser(user: user)
    }

    private func getPlaylists(request: Request) async throws -> [PlaylistsResponse.Playlist] {
        let playlistsResponse = try await request.spotifyClient.get(
            "v1/me/playlists",
            application: request.application,
            auth: .request(request: request)
        ) { request in
            try request.query.encode(PagingData(offset: 0))
        }

        return try playlistsResponse.content.decode(PlaylistsResponse.self).items
    }
}


struct PlaylistsResponse: Content {
    struct Playlist: Content {
        let id: String
        let name: String
    }

    let limit: Int?
    let offset: Int
    let items: [Playlist]
}

struct PagingData: Content {
    var limit: Int = 50
    let offset: Int
}

struct UpdateUserRequest: Content {
    let selectedPlaylistID: String?
    let isActive: Bool

    enum CodingKeys: String, CodingKey {
        case selectedPlaylistID = "selected_playlist_id"
        case isActive = "is_active"
    }
}
