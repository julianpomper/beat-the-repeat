//
//  User.swift
//  
//
//  Created by Julian Pomper on 13.05.23.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema: String = "users"

    @ID(custom: "id", generatedBy: .user)
    var id: String?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Field(key: "name")
    var name: String

    @OptionalField(key: "image_url")
    var imageUrl: String?

    @Field(key: "uri")
    var uri: String

    @Field(key: "token")
    var token: String

    @OptionalField(key: "refresh_token")
    var refreshToken: String?

    @OptionalField(key: "selected_playlist_id")
    var selectedPlaylistID: String?

    @Field(key: "active")
    var isActive: Bool

    init() { }

    init(
        id: String,
        name: String,
        imageUrl: String? = nil,
        uri: String,
        token: String,
        refreshToken: String?,
        selectedPlaylistID: String? = nil,
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.uri = uri
        self.token = token
        self.refreshToken = refreshToken
        self.selectedPlaylistID = selectedPlaylistID
        self.isActive = isActive
    }

}

extension User {
    struct ApiUser: Content {
        let id: String
        let name: String
        let imageURL: String?
        let selectedPlaylistID: String?
        let isActive: Bool

        init(user: User) throws {
            id = try user.requireID()
            name = user.name
            imageURL = user.imageUrl
            selectedPlaylistID = user.selectedPlaylistID
            isActive = user.isActive
        }

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case imageURL = "image_url"
            case selectedPlaylistID = "selected_playlist_id"
            case isActive = "is_active"
        }
    }
}

// not needed
extension User: ModelAuthenticatable {
    static let usernameKey = \User.$name
    static let passwordHashKey = \User.$token

    func verify(password: String) throws -> Bool {
        true // not needed
    }
}

extension User {
    func generateToken() throws -> UserToken {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
}

final class UserToken: Model, Content {
    static let schema = "user_tokens"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "value")
    var value: String

    @Parent(key: "user_id")
    var user: User

    init() { }

    init(value: String, userID: User.IDValue) {
        self.value = value
        self.$user.id = userID
    }
}

extension UserToken: ModelTokenAuthenticatable {
    static let valueKey = \UserToken.$value
    static let userKey = \UserToken.$user

    var isValid: Bool {
        true
    }
}
