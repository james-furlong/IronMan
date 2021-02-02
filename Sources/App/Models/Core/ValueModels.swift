//
//  ValueModels.swift
//  
//
//  Created by James Furlong on 1/2/21.
//

import Vapor
import Fluent

final class NRLValue: Model, Content {
    struct Public {
        let id: UUID
        let roundId: UUID
        let startingValue: Double
        let finishingValue: Double
        let stats: NRLStat
        let score: Double
    }
    
    @ID(key: "id") var id: UUID?
    @Field(key: "round_id") var roundId: UUID
    @Field(key: "starting_value") var startingValue: Double
    @Field(key: "finishing_value") var finishingValue: Double
    @Field(key: "score") var score: Double
    @Parent(key: "player_id") var player: NRLPlayer
    
    static var schema: String { "core_nrl_value" }
    
    init() { }
    
    init(
        id: UUID? = nil,
        roundId: UUID,
        startingValue: Double,
        finishingValue: Double,
        score: Double,
        playerId: UUID
    ) {
        self.id = id
        self.roundId = roundId
        self.startingValue = startingValue
        self.finishingValue = finishingValue
        self.score = score
        self.$player.id = playerId
    }
}

final class NRLStat: Model, Content {
    struct Public {
        let id: UUID
        let allRunMetres: Int
        let allRuns: Int
        let bombKicks: Int
        let crossFieldKicks: Int
        let conversions: Int
        let conversionAttempts: Int
        let dummyHalfRuns: Int
        let dummyHalfRunMetres: Int
        let dummyPasses: Int
        let errors: Int
        let fantasyPointsTotal: Int
        let fieldGoals: Int
        let forcedDropOutKicks: Int
        let fortyTwentyKicks: Int
        let goals: Int
        let goalConversionRate: Decimal
        let grubberKicks: Int
        let handlingErrors: Int
        let hitUps: Int
        let hitUpRunMetres: Int
        let ineffectiveTackles: Int
        let intercepts: Int
        let kicks: Int
        let kicksDead: Int
        let kicksDefused: Int
        let kickMetres: Int
        let kickReturnMetres: Int
        let lineBreakAssists: Int
        let lineBreaks: Int
        let lineEngagedRuns: Int
        let minutesPlayed: Int
        let missedTackles: Int
        let offloads: Int
        let oneOnOneLost: Int
        let oneOnOneSteal: Int
        let onReport: Int
        let passesToRunRatio: Double
        let passes:  Int
        let playTheBallTotal: Int
        let playTheBallAverageSpeed: Double
        let penalties: Int
        let points: Int
        let penaltyGoals: Int
        let postContactMetres: Int
        let receipts: Int
        let ruckInfringements: Int
        let sendOffs: Int
        let sinBins: Int
        let stintOne: Int
        let tackleBreaks: Int
        let tackleEfficiency: Double
        let tacklesMade: Int
        let tries: Int
        let tryAssists: Int
        let twentyFortyKicks: Int
    }
    
    @ID(key: "id") var id: UUID?
    @Parent(key: "value") var value: NRLValue
    @Field(key: "all_run_meters") var allRunMetres: Int
    @Field(key: "all_runs") var allRuns: Int
    @Field(key: "bomb_kicks") var bombKicks: Int
    @Field(key: "cross_field_kicks") var crossFieldKicks: Int
    @Field(key: "conversion") var conversions: Int
    @Field(key: "conversion_attempts") var conversionAttempts: Int
    @Field(key: "dummy_half_runs") var dummyHalfRuns: Int
    @Field(key: "dummy_half_run_metres") var dummyHalfRunMetres: Int
    @Field(key: "dummy_passes") var dummyPasses: Int
    @Field(key: "errors") var errors: Int
    @Field(key: "fantasy_points_total") var fantasyPointsTotal: Int
    @Field(key: "field_goals") var fieldGoals: Int
    @Field(key: "forced_drop_out_kicks") var forcedDropOutKicks: Int
    @Field(key: "forty_twenty_kicks") var fortyTwentyKicks: Int
    @Field(key: "goals") var goals: Int
    @Field(key: "goal_conversion_rate") var goalConversionRate: Decimal
    @Field(key: "grubber_kicks") var grubberKicks: Int
    @Field(key: "handling_errors") var handlingErrors: Int
    @Field(key: "hit_ups") var hitUps: Int
    @Field(key: "hit_up_run_metres") var hitUpRunMetres: Int
    @Field(key: "ineffective_tackles") var ineffectiveTackles: Int
    @Field(key: "intercepts") var intercepts: Int
    @Field(key: "kicks") var kicks: Int
    @Field(key: "kicks_dead") var kicksDead: Int
    @Field(key: "kicks_defused") var kicksDefused: Int
    @Field(key: "kick_metres") var kickMetres: Int
    @Field(key: "kick_metres_returned") var kickReturnMetres: Int
    @Field(key: "line_break_assists") var lineBreakAssists: Int
    @Field(key: "line_breaks") var lineBreaks: Int
    @Field(key: "line_engaged_runs") var lineEngagedRuns: Int
    @Field(key: "minutes_played") var minutesPlayed: Int
    @Field(key: "missed_tackles") var missedTackles: Int
    @Field(key: "offloads") var offloads: Int
    @Field(key: "one_on_one_lost") var oneOnOneLost: Int
    @Field(key: "one_on_one_steal") var oneOnOneSteal: Int
    @Field(key: "on_report") var onReport: Int
    @Field(key: "passes_to_run_ratio") var passesToRunRatio: Double
    @Field(key: "passes") var passes:  Int
    @Field(key: "play_the_ball_total") var playTheBallTotal: Int
    @Field(key: "play_the_ball_average_speed") var playTheBallAverageSpeed: Double
    @Field(key: "penalties") var penalties: Int
    @Field(key: "points") var points: Int
    @Field(key: "penalty_goals") var penaltyGoals: Int
    @Field(key: "post_contact_metres") var postContactMetres: Int
    @Field(key: "receipts") var receipts: Int
    @Field(key: "ruck_infringements") var ruckInfringements: Int
    @Field(key: "send_offs") var sendOffs: Int
    @Field(key: "sin_bins") var sinBins: Int
    @Field(key: "stint_one") var stintOne: Int
    @Field(key: "tackle_breaks") var tackleBreaks: Int
    @Field(key: "tackle_efficiency") var tackleEfficiency: Double
    @Field(key: "tackles_made") var tacklesMade: Int
    @Field(key: "tries") var tries: Int
    @Field(key: "try_assists") var tryAssists: Int
    @Field(key: "twenty_forty_kicks") var twentyFortyKicks: Int
    
    static var schema: String { "core_nrl_stats" }
    
    init() { }
    
    init(
        id: UUID? = nil,
        allRunMetres: Int,
        allRuns: Int,
        bombKicks: Int,
        crossFieldKicks: Int,
        conversions: Int,
        conversionAttempts: Int,
        dummyHalfRuns: Int,
        dummyHalfRunMetres: Int,
        dummyPasses: Int,
        errors: Int,
        fantasyPointsTotal: Int,
        fieldGoals: Int,
        forcedDropOutKicks: Int,
        fortyTwentyKicks: Int,
        goals: Int,
        goalConversionRate: Decimal,
        grubberKicks: Int,
        handlingErrors: Int,
        hitUps: Int,
        hitUpRunMetres: Int,
        ineffectiveTackles: Int,
        intercepts: Int,
        kicks: Int,
        kicksDead: Int,
        kicksDefused: Int,
        kickMetres: Int,
        kickReturnMetres: Int,
        lineBreakAssists: Int,
        lineBreaks: Int,
        lineEngagedRuns: Int,
        minutesPlayed: Int,
        missedTackles: Int,
        offloads: Int,
        oneOnOneLost: Int,
        oneOnOneSteal: Int,
        onReport: Int,
        passesToRunRatio: Double,
        passes:  Int,
        playTheBallTotal: Int,
        playTheBallAverageSpeed: Double,
        penalties: Int,
        points: Int,
        penaltyGoals: Int,
        postContactMetres: Int,
        receipts: Int,
        ruckInfringements: Int,
        sendOffs: Int,
        sinBins: Int,
        stintOne: Int,
        tackleBreaks: Int,
        tackleEfficiency: Double,
        tacklesMade: Int,
        tries: Int,
        tryAssists: Int,
        twentyFortyKicks: Int
    ) {
        self.id = id
        self.allRunMetres = allRunMetres
        self.allRuns = allRuns
        self.bombKicks = bombKicks
        self.crossFieldKicks = crossFieldKicks
        self.conversions = conversions
        self.conversionAttempts = conversionAttempts
        self.dummyHalfRuns = dummyHalfRuns
        self.dummyHalfRunMetres = dummyHalfRunMetres
        self.dummyPasses = dummyPasses
        self.errors = errors
        self.fantasyPointsTotal = fantasyPointsTotal
        self.fieldGoals = fieldGoals
        self.forcedDropOutKicks = forcedDropOutKicks
        self.fortyTwentyKicks = fortyTwentyKicks
        self.goals = goals
        self.goalConversionRate = goalConversionRate
        self.grubberKicks = grubberKicks
        self.handlingErrors = handlingErrors
        self.hitUps = hitUps
        self.hitUpRunMetres = hitUpRunMetres
        self.ineffectiveTackles = ineffectiveTackles
        self.intercepts = intercepts
        self.kicks = kicks
        self.kicksDead = kicksDead
        self.kicksDefused = kicksDefused
        self.kickMetres = kickMetres
        self.kickReturnMetres = kickReturnMetres
        self.lineBreakAssists = lineBreakAssists
        self.lineBreaks = lineBreaks
        self.lineEngagedRuns = lineEngagedRuns
        self.minutesPlayed = minutesPlayed
        self.missedTackles = missedTackles
        self.offloads = offloads
        self.oneOnOneLost = oneOnOneLost
        self.oneOnOneSteal = oneOnOneSteal
        self.onReport = onReport
        self.passesToRunRatio = passesToRunRatio
        self.passes = passes
        self.playTheBallTotal = playTheBallTotal
        self.playTheBallAverageSpeed = playTheBallAverageSpeed
        self.penalties = penalties
        self.points = points
        self.penaltyGoals = penaltyGoals
        self.postContactMetres = postContactMetres
        self.receipts = receipts
        self.ruckInfringements = ruckInfringements
        self.sendOffs = sendOffs
        self.sinBins = sinBins
        self.stintOne = stintOne
        self.tackleBreaks = tackleBreaks
        self.tackleEfficiency = tackleEfficiency
        self.tacklesMade = tacklesMade
        self.tries = tries
        self.tryAssists = tryAssists
        self.twentyFortyKicks = twentyFortyKicks
    }
}
