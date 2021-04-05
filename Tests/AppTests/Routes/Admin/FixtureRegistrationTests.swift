@testable import App
import XCTVapor

final class FixtureRegistrationTests: XCTestCase {
    func testAdminNrlPlayerRegistration() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try app.autoRevert().wait()
        try app.autoMigrate().wait()
        
        let user = User(email: "test@test.com", passwordHash: "foo", accessLevel: .Admin)
        let _ = try user.save(on: app.db).wait()
        
        let token: Token = try user.createToken(source: .login)
        try token.save(on: app.db).wait()
        let tokenValue = token.value
        
        let match = NRLMatch.Public(
            id: UUID(),
            referenceId: "",
            name: "Test Match",
            location: "TestLocation",
            startDateTime: nil,
            matchMode: .Pre,
            matchState: .Upcoming,
            venue: "TestVenuw",
            venueCity: "TestVenueCity",
            matchUrl: "TestMatchUrl",
            homeTeamId: 1,
            awayTeamId: 2,
            result: nil
        )
        let round = NRLRound.Public(
            id: UUID(),
            round: 1,
            roundTitle: "Test Round",
            roundStartDateTime: nil,
            roundEndDateTime: nil,
            matches: [match]
        )
        
        let request = NRLFixtureRegister(rounds: [round])
        
        try app.test(.POST, "/fixture/nrl/", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: tokenValue)
            try req.content.encode(request)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .created)
        })
    }
}
