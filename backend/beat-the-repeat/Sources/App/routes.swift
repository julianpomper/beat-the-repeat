import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: EntryController())
    try app.register(collection: CallbackController())

    try app.grouped(UserToken.authenticator())
        .register(collection: ApiController())
}
