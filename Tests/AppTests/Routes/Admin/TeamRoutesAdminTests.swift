@testable import App
import XCTVapor

final class TeamRoutesAdminTests: XCTestCase {
    let user1 = User(email: "test@test.com", passwordHash: "Test", accessLevel: .User)
    let user2 = User(email: "test2@test.com", passwordHash: "Test2", accessLevel: .User)
    let adminUser = User(email: "admin@test.com", passwordHash: "adminPassword", accessLevel: .Admin)
    
    func testAdminTeamRegistration() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try app.autoRevert().wait()
        try app.autoMigrate().wait()
        
        user1.save(on: app.db)
        
        let request = NRLUserTeamModel(
            userId: user1.id!,
            teamName: "Test team",
            teamColor: "Test color",
            teamLogo: 0
        )
//        let request = NRLPlayersRegister(players: [player])
//
//        try app.test(.POST, "/team/admin/nrl/", beforeRequest: { req in
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
