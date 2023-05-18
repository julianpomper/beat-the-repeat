//
//  CurrentlyPlayingCron.swift
//  
//
//  Created by Julian Pomper on 18.05.23.
//

import Vapor
import VaporCron

struct CurrentlyPlayingSong: Decodable {
    let uri: String
    let playlistURI: String
    
    enum CodingKeys: CodingKey {
        case item
        case context
    }
    
    enum SubCodingKeys: CodingKey {
        case uri
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uri = try container.nestedContainer(keyedBy: SubCodingKeys.self, forKey: .item).decode(String.self, forKey: .uri)
        self.playlistURI = try container.nestedContainer(keyedBy: SubCodingKeys.self, forKey: .context).decode(String.self, forKey: .uri)
    }
}

struct DeleteTrackRequest: Content {
    struct Track: Content {
        let uri: String
    }
    
    let tracks: [Track]
}

public struct CurrentlyPlayingCron: AsyncVaporCronSchedulable {
    public typealias T = Void
    
    public static var expression: String {
        "*/1 * * * *" // or add one more * to launch every 1st second
    }
    
    public static func task(on application: Application) async throws -> Void {
        application.logger.info("Start fetching playlists")
        
        let onUsers = try await User.query(on: application.db)
            .filter(\.$isActive, .equal, true)
            .filter(\.$selectedPlaylistID, .notEqual, nil)
            .all()
        
        application.logger.info("Found \(onUsers.count) users matching criteria")
        
        for user in onUsers {
            let userID = try user.requireID()
            do {
                let currentlyPlayingResponse: CurrentlyPlayingSong
                do {
                    currentlyPlayingResponse = try await application.spotifyClient.get(
                        "v1/me/player/currently-playing",
                        application: application,
                        auth: .userId(userID)
                    ).content.decode(CurrentlyPlayingSong.self)
                } catch {
                    application.logger.info("User \(userID) isn't currently playing any tracks")
                    throw error
                }
                
                guard let playlistID = user.selectedPlaylistID,
                      let currentPlaylistID = currentlyPlayingResponse.playlistURI.split(separator: ":").last,
                      playlistID == currentPlaylistID
                else {
                    application.logger.info("User \(userID) is playing playlist \(user.selectedPlaylistID ?? "NONE") which isn't selected")
                    continue
                }
                
                _ = try await application.spotifyClient.delete(
                    "v1/playlists/\(playlistID)/tracks",
                    application: application,
                    auth: .userId(userID)
                ) { request in
                    try request.content.encode(
                        DeleteTrackRequest(
                            tracks: [
                                DeleteTrackRequest.Track(uri: currentlyPlayingResponse.uri)
                            ]
                        )
                    )
                }
                application.logger.info("Deleted track \(currentlyPlayingResponse.uri) for \(userID)")
            } catch {
                application.logger.error("Failed to delete currently playing track for user id \(userID)")
            }
            
        }
    }
}
