@testable import App
import XCTVapor

final class ResultsPostTests: XCTestCase {
    
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
    
    let app = Application(.testing)
    let stat = NRLStat.Public.emptyStats()
    let round = NRLRound(
        round: 1,
        roundTitle: "Round 1",
        roundStartDateTime: Date(),
        roundEndDateTime: Date()
    )
    let player = NRLPlayer(
        firstName: "Player",
        lastName: "Test",
        referenceId: "5555",
        preferredPosition: NRLPosition.prop,
        actualPosition: NRLPosition.prop,
        currentValue: 125_000,
        team: NRLTeamEnum.brisbaneBronos,
        season: 2021
    )
    
    func testResultRegistration() throws {
        defer { app.shutdown() }
        try configure(app)
        
        try app.autoRevert().wait()
        try app.autoMigrate().wait()
        
        let result = NRLResult.Public(
            matchReferenceId: "1234567890",
            score: "12-6",
            gameSeconds: 4_800,
            homeScore: 12,
            homeHalfTimeScore: 12,
            awayScore: 6,
            awayHalfTimeScore: 0,
            homeTries: 2,
            awayTries: 1,
            homeConversions: 2,
            awayConversions: 1,
            homeConversionAttempts: 2,
            awayConversionAttempts: 1,
            homePenaltyGoals: 0,
            awayPenaltyGoals: 0,
            homePenaltyGoalAttempts: 0,
            awayPenaltyGoalAttempts: 0,
            homeFieldGoals: 0,
            awayFieldGoals: 0,
            homeFieldGoalAttempts: 0,
            awayFieldGoalAttempts: 0,
            homeSinBins: 0,
            awaySinBins: 0,
            homeSendOffs: 0,
            awaySendOffs: 0,
            stats: [stat]
        )
        
        try setupAdminUser(app)
        
        try round.save(on: app.db).wait()
        let match = NRLMatch(
            referenceId: "1234567890",
            name: "Cowboys Vs Storm",
            location: "Townsville",
            startDateTime: Date(),
            matchMode: NRLMatchMode.Pre,
            matchState: NRLMatchState.Upcoming,
            venue: "Smiles Stadium",
            venueCity: "Townsville",
            matchUrl: "http://test.com",
            homeTeamId: 123,
            awayTeamId: 456,
            round_id: round.id!
        )
        try match.save(on: app.db).wait()
        try player.save(on: app.db).wait()
        
        let request = NRLResultsRegister(results: [result])
        
        try app.test(.POST, "/result/nrl/", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: token.value)
            try req.content.encode(request)
        }, afterResponse: { response in
            NRLResult.query(on: app.db).first().unwrap(orError: Abort(.notFound)).whenSuccess { resultResponse in
                XCTAssertEqual(resultResponse.$match.id, match.id)
                XCTAssertEqual(resultResponse.score, result.score)
                XCTAssertEqual(resultResponse.gameSeconds, result.gameSeconds)
                XCTAssertEqual(resultResponse.homeScore, result.homeScore)
                XCTAssertEqual(resultResponse.homeHalfTimeScore, result.homeHalfTimeScore)
                XCTAssertEqual(resultResponse.awayScore, result.awayScore)
                XCTAssertEqual(resultResponse.awayHalfTimeScore, result.awayHalfTimeScore)
                XCTAssertEqual(resultResponse.homeTries, result.homeTries)
                XCTAssertEqual(resultResponse.awayTries, result.awayTries)
                XCTAssertEqual(resultResponse.homeConversions, result.homeConversions)
                XCTAssertEqual(resultResponse.awayConversions, result.awayConversions)
                XCTAssertEqual(resultResponse.homeConversionAttempts, result.homeConversionAttempts)
                XCTAssertEqual(resultResponse.awayConversionAttempts, result.awayConversionAttempts)
                XCTAssertEqual(resultResponse.homePenaltyGoals, result.homePenaltyGoals)
                XCTAssertEqual(resultResponse.awayPenaltyGoals, result.awayPenaltyGoals)
                XCTAssertEqual(resultResponse.homePenaltyGoalAttempts, result.homePenaltyGoalAttempts)
                XCTAssertEqual(resultResponse.awayPenaltyGoalAttempts, result.awayPenaltyGoalAttempts)
                XCTAssertEqual(resultResponse.homeFieldGoals, result.homeFieldGoals)
                XCTAssertEqual(resultResponse.awayFieldGoals, result.awayFieldGoals)
                XCTAssertEqual(resultResponse.homeFieldGoalAttempts, result.homeFieldGoalAttempts)
                XCTAssertEqual(resultResponse.awayFieldGoalAttempts, result.awayFieldGoalAttempts)
                XCTAssertEqual(resultResponse.homeSinBins, result.homeSinBins)
                XCTAssertEqual(resultResponse.awaySinBins, result.awaySinBins)
                XCTAssertEqual(resultResponse.homeSendOffs, result.homeSendOffs)
                XCTAssertEqual(resultResponse.awaySendOffs, result.awaySendOffs)
            }
            NRLValue.query(on: app.db).first().unwrap(or: Abort(.notFound)).whenSuccess { valueResponse in
                XCTAssertEqual(valueResponse.$player.id, self.player.id)
                XCTAssertEqual(valueResponse.$match.id, match.id)
                XCTAssertEqual(valueResponse.startingValue, 125_000)
                XCTAssertEqual(valueResponse.finishingValue, 125_000)
                XCTAssertEqual(valueResponse.score, NRLStat.score(from: self.stat))
            }
            NRLStat.query(on: app.db).first().unwrap(or: Abort(.notFound)).whenSuccess { resultStat in
                
            }
            XCTAssertEqual(response.status, .created)
        })
    }
    
    func testResultUpdate() throws {
        defer { app.shutdown() }
        try configure(app)
        
        try app.autoRevert().wait()
        try app.autoMigrate().wait()
    }
}
