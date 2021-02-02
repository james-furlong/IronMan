import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    let hostname: String
    let port: Int
    let username: String
    let password: String
    let database: String
    
    switch app.environment {
        case .development:
            hostname = Environment.get("DATABASE_HOST_DEV") ?? "localhost"
            port = Environment.get("DATABASE_PORT_DEV").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber
            username = Environment.get("DATABASE_USERNAME_DEV") ?? "vapor_username"
            password = Environment.get("DATABASE_PASSWORD_DEV") ?? "vapor_password"
            database = Environment.get("DATABASE_NAME_DEV") ?? "vapor_database"
        
        case .testing:
            hostname = "localhost"
            port = 5432
            username = "admin"
            password = "admin"
            database = "ironman_test"
            
        default:
            hostname = Environment.get("DATABASE_HOST_PROD") ?? "localhost"
            port = Environment.get("DATABASE_PORT_PROD").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber
            username = Environment.get("DATABASE_USERNAME_PROD") ?? "vapor_username"
            password = Environment.get("DATABASE_PASSWORD_PROD") ?? "vapor_password"
            database = Environment.get("DATABASE_NAME_PROD") ?? "vapor_database"
    }

    app.databases.use(.postgres(
        hostname: hostname,
        port: port,
        username: username,
        password: password,
        database: database
    ), as: .psql)

    app.migrations.add(CreateUsers())
    app.migrations.add(CreateTokens())
    app.migrations.add(CreateUserDetail())
    app.migrations.add(CreateNRLPlayer())
    app.migrations.add(CreateNRLRoundMatchTeam())
    
//    var commandConfig = CommandConfig.default()
    
    app.logger.logLevel = .debug
    
    try app.autoMigrate().wait()

    // register routes
    try routes(app)
}
