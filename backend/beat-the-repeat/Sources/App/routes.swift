import Fluent
import Vapor

func routes(_ app: Application) throws {
    let api = app.grouped("api")
    
    try api.register(collection: EntryController())
    try api.register(collection: CallbackController())

    try api.grouped(UserToken.authenticator())
        .register(collection: ApiController())
}
