//
//  File.swift
//  
//
//  Created by Max Gierlachowski (Private) on 13.05.23.
//

import Vapor
import Foundation

struct EntryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get(use: index)
    }
    
    func index(req: Request) async throws -> Response {
        let scopes: [String] = [
            "playlist-read-private",
            "playlist-read-collaborative",
            "playlist-modify-private",
            "playlist-modify-public",
            "user-read-currently-playing",
        ]

        var url = URLComponents(string: "https://accounts.spotify.com/authorize")!
        url.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: Environment.get("BTR_CLIENT_ID")!),
            URLQueryItem(name: "redirect_uri", value: "\(Environment.get("BTR_DOMAIN")!)/callback"),
            URLQueryItem(name: "scope", value: scopes.joined(separator: " "))
        ]
        return req.redirect(to: url.string!)
    }
}
