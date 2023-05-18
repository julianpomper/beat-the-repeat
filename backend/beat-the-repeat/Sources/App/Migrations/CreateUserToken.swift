import Fluent

struct CreateUserToken: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(UserToken.schema)
            .id()
            .field("value", .string, .required).unique(on: "value")
            .field("user_id", .string, .required).unique(on: "user_id")
            .foreignKey("user_id", references: User.schema, "id", onDelete: .cascade)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(UserToken.schema).delete()
    }
}
