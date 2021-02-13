import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: UserController())
    try app.register(collection: PlayerController())
    try app.register(collection: FixtureController())
    try app.register(collection: ResultController())
}
