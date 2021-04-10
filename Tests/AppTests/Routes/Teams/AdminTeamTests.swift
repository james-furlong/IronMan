@testable import App
import XCTVapor

final class TeamPostTests: XCTestCase {
    
    private var user: User!
    private var token: Token!
    
    func setupAdminUser(_ app: Application) throws {
        user = User(email: "test@test.com", passwordHash: "foo", accessLevel: .Admin)
        let _ = try user.save(on: app.db).wait()
        
        token = try user.createToken(source: .login)
        try token.save(on: app.db).wait()
    }
    
    func setupRegularUser(_ app: Application) throws {
        user = User(email: "test@test.com", passwordHash: "foo", accessLevel: .User)
        let _ = try user.save(on: app.db).wait()
        
        token = try user.createToken(source: .login)
        try token.save(on: app.db).wait()
    }
    
    let user1 = User(email: "test@test.com", passwordHash: "Test", accessLevel: .User)
    let user2 = User(email: "test2@test.com", passwordHash: "Test2", accessLevel: .User)
    let adminUser = User(email: "admin@test.com", passwordHash: "adminPassword", accessLevel: .Admin)
    
    func testAdminTeamRegistration() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try app.autoRevert().wait()
        try app.autoMigrate().wait()
        
//        let request = NRLUserTeamModel(
//            userId: user1.id!,
//            teamName: "Test team",
//            teamColor: "Test color",
//            teamLogo: 0
//        )
//        let request = NRLAdmin(players: [player])
        
        try setupAdminUser(app)

//        try app.test(.POST, "/team/admin/nrl/", beforeRequest: { req in
//            req.headers.bearerAuthorization = .init(token: token.value)
//            try req.content.encode(request)
//        }, afterResponse: { response in
//            XCTAssertEqual(response.status, .created)
//            NRLPlayer.query(on: app.db).first().unwrap(or: Abort(.notFound)).whenComplete{ savedPlayer in
//                switch savedPlayer {
//                    case .success(let temp):
//                        XCTAssertEqual(temp, player)
//                    case .failure(let error):
//                        print(error)
//                }
//            }
//        })
    }
}
