@testable import App
import XCTVapor

final class FixturePostTests: XCTestCase {
    
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
            req.headers.bearerAuthorization = .init(token: token.value)
            try req.content.encode(request)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .created)
        })
    }
}
