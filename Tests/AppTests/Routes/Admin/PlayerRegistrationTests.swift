@testable import App
import XCTVapor

final class PlayerRegistrationTests: XCTestCase {
    func testAdminNrlPlayerRegistration() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try app.autoRevert().wait()
        try app.autoMigrate().wait()
        
        let user = User(
            email: "admin@user.com",
            passwordHash: "",
            accessLevel: .Admin
        )
        try user.save(on: app.db).wait()
        let token = try user.createToken(source: .login)
        try token.save(on: app.db).wait()

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
            req.headers.bearerAuthorization = BearerAuthorization(token: token.value)
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
