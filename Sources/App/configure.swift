import Fluent
import FluentPostgresDriver
import Vapor
import WebKit

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    let hostname = Environment.get("DATABASE_HOST") ?? "localhost"
    let port = Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber
    let username = Environment.get("DATABASE_USERNAME") ?? "vapor_username"
    let password = Environment.get("DATABASE_PASSWORD") ?? "vapor_password"
    let database = Environment.get("DATABASE_NAME") ?? "vapor_database"

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
    
    app.logger.logLevel = .debug
    
    try app.autoMigrate().wait()
    
    var jsonText: String?
    let url = URL(string: "https://www.melbournestorm.com.au/teams/")
    let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
        let rawData = String(data: data!, encoding: String.Encoding.utf8)
        if let startRange = rawData?.range(of: "profileGroups") {
            let startText = rawData?.substring(from: startRange.lowerBound)
            let rangeText = """
            \"\r\n
            """
            if let endRange = startText?.range(of:rangeText) {
                jsonText = startText?.substring(to: endRange.lowerBound)
                let json1 = jsonText?.replacingOccurrences(
                    of: "&quot;",
                    with: "\""
                )
                let json2 = json1?.replacingOccurrences(of: "\"", with: "")
//                let temp = json1?.firstIndex(of: "\"")
//                json1?.remove(at: temp!)
                
                print(json2)
            }
        }
        
//        rawData?.spl
    }
    task.resume()

    // register routes
    try routes(app)
}
