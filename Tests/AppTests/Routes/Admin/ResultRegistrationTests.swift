@testable import App
import XCTVapor

final class ResultsRegistrationTests: XCTestCase {
    let app = Application(.testing)
    let stat = NRLStat.Public(id: nil, playerReferenceId: "5555", allRunMetres: 0, allRuns: 0, bombKicks: 0, crossFieldKicks: 0, conversions: 0, conversionAttempts: 0, dummyHalfRuns: 0, dummyHalfRunMetres: 0, dummyPasses: 0, errors: 0, fantasyPointsTotal: 0, fieldGoals: 0, forcedDropOutKicks: 0, fortyTwentyKicks: 0, goals: 0, goalConversionRate: 0, grubberKicks: 0, handlingErrors: 0, hitUps: 0, hitUpRunMetres: 0, ineffectiveTackles: 0, intercepts: 0, kicks: 0, kicksDead: 0, kicksDefused: 0, kickMetres: 0, kickReturnMetres: 0, lineBreakAssists: 0, lineBreaks: 0, lineEngagedRuns: 0, minutesPlayed: 0, missedTackles: 0, offloads: 0, oneOnOneLost: 0, oneOnOneSteal: 0, onReport: 0, passesToRunRatio: 0, passes: 0, playTheBallTotal: 0, playTheBallAverageSpeed: 0, penalties: 0, points: 0, penaltyGoals: 0, postContactMetres: 0, receipts: 0, ruckInfringements: 0, sendOffs: 0, sinBins: 0, stintOne: 0, tackleBreaks: 0, tackleEfficiency: 0, tacklesMade: 0, tries: 0, tryAssists: 0, twentyFortyKicks: 0)
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
