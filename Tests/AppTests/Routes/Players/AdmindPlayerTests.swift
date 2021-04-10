@testable import App
import XCTVapor

final class PlayerPostTests: XCTestCase {
    
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
    
    func testAdminNrlPlayerRegistration() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try app.autoRevert().wait()
        try app.autoMigrate().wait()
        
        try setupAdminUser(app)
        let tokenValue = token.value

        let player = NRLPlayer(
            firstName: "TestFirstName",
            lastName: "TestLastName",
            referenceId: "1",
            preferredPosition: .fullback,
            actualPosition: .fullback,
            currentValue: 0,
            team: .brisbaneBronos,
            season: 2021
        )
        let request = NRLPlayersRegister(players: [player])
        
        try app.test(.POST, "/players/nrl/admin/", beforeRequest: { req in
            try req.content.encode(request)
            req.headers.bearerAuthorization = .init(token: tokenValue)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .created)
            NRLPlayer.query(on: app.db).first().unwrap(or: Abort(.notFound)).whenComplete{ savedPlayer in
                switch savedPlayer {
                    case .success(let temp):
                        XCTAssertEqual(temp, player)
                    case .failure(let error):
                        print(error)
                }
            }
        })
    }
}
