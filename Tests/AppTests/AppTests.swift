@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testAdminNrlPlayerRegistration() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try app.autoRevert().wait()
        try app.autoMigrate().wait()

        let player = NRLPlayer(
            firstName: "TestFirstName",
            lastName: "TestLastName",
            playerNumber: 1,
            preferredPosition: .fullback,
            actualPosition: .fullback,
            value: 0,
            team: .brisbaneBronos,
            season: 2021
        )
        let request = NRLPlayersRegister(players: [player])
        
        try app.test(.POST, "/players/nrl/", beforeRequest: { req in
            try req.content.encode(request)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .created)
        })
    }
    
    
}
