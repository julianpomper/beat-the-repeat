import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(User.schema)
            .field(.id, .string, .identifier(auto: false))
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("name", .string, .required)
            .field("image_url", .string)
            .field("uri", .string, .required)
            .field("token", .string, .required)
            .field("refresh_token", .string)
            .field("selected_playlist_id", .string)
            .field("active", .bool, .sql(.default("true")))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(User.schema).delete()
    }
}
