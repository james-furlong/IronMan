//
//  File.swift
//  
//
//  Created by James Furlong on 5/2/21.
//

import Fluent
import Vapor

final class NRLStat: Model, Content {
    struct Public: Content {
        let id: UUID?
        let playerReferenceId: String
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
        let goalConversionRate: Double
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
    @Field(key: "goal_conversion_rate") var goalConversionRate: Double
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
    
    static func baseState(valueId: UUID) -> NRLStat {
        NRLStat(
            valueId: valueId,
            allRunMetres: 0,
            allRuns: 0,
            bombKicks: 0,
            crossFieldKicks: 0,
            conversions: 0,
            conversionAttempts: 0,
            dummyHalfRuns: 0,
            dummyHalfRunMetres: 0,
            dummyPasses: 0,
            errors: 0,
            fantasyPointsTotal: 0,
            fieldGoals: 0,
            forcedDropOutKicks: 0,
            fortyTwentyKicks: 0,
            goals: 0,
            goalConversionRate: 0,
            grubberKicks: 0,
            handlingErrors: 0,
            hitUps: 0,
            hitUpRunMetres: 0,
            ineffectiveTackles: 0,
            intercepts: 0,
            kicks: 0,
            kicksDead: 0,
            kicksDefused: 0,
            kickMetres: 0,
            kickReturnMetres: 0,
            lineBreakAssists: 0,
            lineBreaks: 0,
            lineEngagedRuns: 0,
            minutesPlayed: 0,
            missedTackles: 0,
            offloads: 0,
            oneOnOneLost: 0,
            oneOnOneSteal: 0,
            onReport: 0,
            passesToRunRatio: 0,
            passes: 0,
            playTheBallTotal: 0,
            playTheBallAverageSpeed: 0,
            penalties: 0,
            points: 0,
            penaltyGoals: 0,
            postContactMetres: 0,
            receipts: 0,
            ruckInfringements: 0,
            sendOffs: 0,
            sinBins: 0,
            stintOne: 0,
            tackleBreaks: 0,
            tackleEfficiency: 0,
            tacklesMade: 0,
            tries: 0,
            tryAssists: 0,
            twentyFortyKicks: 0
        )
    }
    
    init() { }
    
    init(from publicStat: NRLStat.Public, valueId: UUID) {
        self.id = publicStat.id
        self.$value.id = valueId
        self.allRunMetres = publicStat.allRunMetres
        self.allRuns = publicStat.allRuns
        self.bombKicks = publicStat.bombKicks
        self.crossFieldKicks = publicStat.crossFieldKicks
        self.conversions = publicStat.conversions
        self.conversionAttempts = publicStat.conversionAttempts
        self.dummyHalfRuns = publicStat.dummyHalfRuns
        self.dummyHalfRunMetres = publicStat.dummyHalfRunMetres
        self.dummyPasses = publicStat.dummyPasses
        self.errors = publicStat.errors
        self.fantasyPointsTotal = publicStat.fantasyPointsTotal
        self.fieldGoals = publicStat.fieldGoals
        self.forcedDropOutKicks = publicStat.forcedDropOutKicks
        self.fortyTwentyKicks = publicStat.fortyTwentyKicks
        self.goals = publicStat.goals
        self.goalConversionRate = publicStat.goalConversionRate
        self.grubberKicks = publicStat.grubberKicks
        self.handlingErrors = publicStat.handlingErrors
        self.hitUps = publicStat.hitUps
        self.hitUpRunMetres = publicStat.hitUpRunMetres
        self.ineffectiveTackles = publicStat.ineffectiveTackles
        self.intercepts = publicStat.intercepts
        self.kicks = publicStat.kicks
        self.kicksDead = publicStat.kicksDead
        self.kicksDefused = publicStat.kicksDefused
        self.kickMetres = publicStat.kickMetres
        self.kickReturnMetres = publicStat.kickReturnMetres
        self.lineBreakAssists = publicStat.lineBreakAssists
        self.lineBreaks = publicStat.lineBreaks
        self.lineEngagedRuns = publicStat.lineEngagedRuns
        self.minutesPlayed = publicStat.minutesPlayed
        self.missedTackles = publicStat.missedTackles
        self.offloads = publicStat.offloads
        self.oneOnOneLost = publicStat.oneOnOneLost
        self.oneOnOneSteal = publicStat.oneOnOneSteal
        self.onReport = publicStat.onReport
        self.passesToRunRatio = publicStat.passesToRunRatio
        self.passes = publicStat.passes
        self.playTheBallTotal = publicStat.playTheBallTotal
        self.playTheBallAverageSpeed = publicStat.playTheBallAverageSpeed
        self.penalties = publicStat.penalties
        self.points = publicStat.points
        self.penaltyGoals = publicStat.penaltyGoals
        self.postContactMetres = publicStat.postContactMetres
        self.receipts = publicStat.receipts
        self.ruckInfringements = publicStat.ruckInfringements
        self.sendOffs = publicStat.sendOffs
        self.sinBins = publicStat.sinBins
        self.stintOne = publicStat.stintOne
        self.tackleBreaks = publicStat.tackleBreaks
        self.tackleEfficiency = publicStat.tackleEfficiency
        self.tacklesMade = publicStat.tacklesMade
        self.tries = publicStat.tries
        self.tryAssists = publicStat.tryAssists
        self.twentyFortyKicks = publicStat.twentyFortyKicks
    }
    
    init(
        id: UUID? = nil,
        valueId: UUID,
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
        goalConversionRate: Double,
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
        self.$value.id = valueId
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
    
    
    enum StatPoints: Double {
        case allRunMetres
        case allRuns
        case bombKicks
        case crossFieldKicks
        case conversions
        case conversionAttempts
        case dummyHalfRuns
        case dummyHalfRunMetres
        case dummyPasses
        case errors
        case fieldGoals
        case forcedDropOutKicks
        case fortyTwentyKicks
        case goals
        case grubberKicks
        case handlingErrors
        case hitUps
        case hitUpRunMetres
        case ineffectiveTackles
        case intercepts
        case kicks
        case kicksDead
        case kicksDefused
        case kickMetres
        case kickReturnMetres
        case lineBreakAssists
        case lineBreaks
        case lineEngagedRuns
        case missedTackles
        case offloads
        case oneOnOneLost
        case oneOnOneSteal
        case onReport
        case playTheBallAverageSpeed
        case penalties
        case points
        case penaltyGoals
        case postContactMetres
        case ruckInfringements
        case sendOffs
        case sinBins
        case tackleBreaks
        case tacklesMade
        case tries
        case tryAssists
        case twentyFortyKicks
        
        var assignedPoints: Double {
            switch self {
                case .allRunMetres: return 0.1
                case .allRuns: return 0.5
                case .bombKicks: return 1
                case .crossFieldKicks: return 1
                case .conversions: return 5
                case .conversionAttempts: return 1
                case .dummyHalfRuns: return 2
                case .dummyHalfRunMetres: return 0.1
                case .errors: return -10
                case .fieldGoals: return 5
                case .forcedDropOutKicks: return 5
                case .fortyTwentyKicks: return 10
                case .goals: return 5
                case .grubberKicks: return 3
                case .handlingErrors: return -10
                case .hitUps: return 4
                case .hitUpRunMetres: return 0.1
                case .ineffectiveTackles: return -5
                case .intercepts: return 10
                case .kicks: return 2
                case .kicksDead: return 2
                case .kicksDefused: return 3
                case .kickMetres: return 0.05
                case .kickReturnMetres: return 0.5
                case .lineBreakAssists: return 1
                case .lineBreaks: return 5
                case .lineEngagedRuns: return 1
                case .missedTackles: return -5
                case .offloads: return 5
                case .oneOnOneLost: return -10
                case .oneOnOneSteal: return 10
                case .onReport: return -10
                case .playTheBallAverageSpeed: return 0.3
                case .penalties: return -10
                case .points: return 3
                case .penaltyGoals: return 5
                case .postContactMetres: return 0.5
                case .ruckInfringements: return -5
                case .sendOffs: return -20
                case .sinBins: return -50
                case .tackleBreaks: return 1
                case .tacklesMade: return 1
                case .tries: return 10
                case .tryAssists: return 5
                case .twentyFortyKicks: return 10
                default: return 0
            }
        }
    }
    
    static func score(from stat: NRLStat.Public) -> Double {
        var scores: [Double] = []
        scores.append(Double(stat.allRunMetres) * StatPoints.allRunMetres.assignedPoints)
        scores.append(Double(stat.allRuns) * StatPoints.allRuns.assignedPoints)
        scores.append(Double(stat.bombKicks) * StatPoints.bombKicks.assignedPoints)
        scores.append(Double(stat.crossFieldKicks) * StatPoints.crossFieldKicks.assignedPoints)
        scores.append(Double(stat.conversions) * StatPoints.conversions.assignedPoints)
        scores.append(Double(stat.conversionAttempts) * StatPoints.conversionAttempts.assignedPoints)
        scores.append(Double(stat.dummyHalfRuns) * StatPoints.dummyHalfRuns.assignedPoints)
        scores.append(Double(stat.dummyHalfRunMetres) * StatPoints.dummyHalfRunMetres.assignedPoints)
        scores.append(Double(stat.errors) * StatPoints.errors.assignedPoints)
        scores.append(Double(stat.fieldGoals) * StatPoints.fieldGoals.assignedPoints)
        scores.append(Double(stat.forcedDropOutKicks) * StatPoints.forcedDropOutKicks.assignedPoints)
        scores.append(Double(stat.fortyTwentyKicks) * StatPoints.fortyTwentyKicks.assignedPoints)
        scores.append(Double(stat.goals) * StatPoints.goals.assignedPoints)
        scores.append(Double(stat.grubberKicks) * StatPoints.grubberKicks.assignedPoints)
        scores.append(Double(stat.handlingErrors) * StatPoints.handlingErrors.assignedPoints)
        scores.append(Double(stat.hitUps) * StatPoints.hitUps.assignedPoints)
        scores.append(Double(stat.hitUpRunMetres) * StatPoints.hitUpRunMetres.assignedPoints)
        scores.append(Double(stat.ineffectiveTackles) * StatPoints.ineffectiveTackles.assignedPoints)
        scores.append(Double(stat.intercepts) * StatPoints.intercepts.assignedPoints)
        scores.append(Double(stat.kicks) * StatPoints.kicks.assignedPoints)
        scores.append(Double(stat.kicksDead) * StatPoints.kicksDead.assignedPoints)
        scores.append(Double(stat.kicksDefused) * StatPoints.kicksDefused.assignedPoints)
        scores.append(Double(stat.kickMetres) * StatPoints.kickMetres.assignedPoints)
        scores.append(Double(stat.kickReturnMetres) * StatPoints.kickReturnMetres.assignedPoints)
        scores.append(Double(stat.lineBreakAssists) * StatPoints.lineBreakAssists.assignedPoints)
        scores.append(Double(stat.lineBreaks) * StatPoints.lineBreaks.assignedPoints)
        scores.append(Double(stat.lineEngagedRuns) * StatPoints.lineEngagedRuns.assignedPoints)
        scores.append(Double(stat.missedTackles) * StatPoints.missedTackles.assignedPoints)
        scores.append(Double(stat.offloads) * StatPoints.offloads.assignedPoints)
        scores.append(Double(stat.oneOnOneLost) * StatPoints.oneOnOneLost.assignedPoints)
        scores.append(Double(stat.oneOnOneSteal) * StatPoints.oneOnOneSteal.assignedPoints)
        scores.append(Double(stat.onReport) * StatPoints.onReport.assignedPoints)
        scores.append(Double(stat.playTheBallAverageSpeed) * StatPoints.playTheBallAverageSpeed.assignedPoints)
        scores.append(Double(stat.penalties) * StatPoints.penalties.assignedPoints)
        scores.append(Double(stat.points) * StatPoints.points.assignedPoints)
        scores.append(Double(stat.penaltyGoals) * StatPoints.penaltyGoals.assignedPoints)
        scores.append(Double(stat.postContactMetres) * StatPoints.postContactMetres.assignedPoints)
        scores.append(Double(stat.ruckInfringements) * StatPoints.ruckInfringements.assignedPoints)
        scores.append(Double(stat.sendOffs) * StatPoints.sendOffs.assignedPoints)
        scores.append(Double(stat.sinBins) * StatPoints.sinBins.assignedPoints)
        scores.append(Double(stat.tackleBreaks) * StatPoints.tackleBreaks.assignedPoints)
        scores.append(Double(stat.tacklesMade) * StatPoints.tacklesMade.assignedPoints)
        scores.append(Double(stat.tries) * StatPoints.tries.assignedPoints)
        scores.append(Double(stat.tryAssists) * StatPoints.tryAssists.assignedPoints)
        scores.append(Double(stat.twentyFortyKicks) * StatPoints.twentyFortyKicks.assignedPoints)
        
        return scores.sum()
    }
}

extension NRLStat.Public {
    static func emptyStats() -> NRLStat.Public {
        NRLStat.Public(
            id: nil,
            playerReferenceId: "5555",
            allRunMetres: 0,
            allRuns: 0,
            bombKicks: 0,
            crossFieldKicks: 0,
            conversions: 0,
            conversionAttempts: 0,
            dummyHalfRuns: 0,
            dummyHalfRunMetres: 0,
            dummyPasses: 0,
            errors: 0,
            fantasyPointsTotal: 0,
            fieldGoals: 0,
            forcedDropOutKicks: 0,
            fortyTwentyKicks: 0,
            goals: 0,
            goalConversionRate: 0,
            grubberKicks: 0,
            handlingErrors: 0,
            hitUps: 0,
            hitUpRunMetres: 0,
            ineffectiveTackles: 0,
            intercepts: 0,
            kicks: 0,
            kicksDead: 0,
            kicksDefused: 0,
            kickMetres: 0,
            kickReturnMetres: 0,
            lineBreakAssists: 0,
            lineBreaks: 0,
            lineEngagedRuns: 0,
            minutesPlayed: 0,
            missedTackles: 0,
            offloads: 0,
            oneOnOneLost: 0,
            oneOnOneSteal: 0,
            onReport: 0,
            passesToRunRatio: 0,
            passes: 0,
            playTheBallTotal: 0,
            playTheBallAverageSpeed: 0,
            penalties: 0,
            points: 0,
            penaltyGoals: 0,
            postContactMetres: 0,
            receipts: 0,
            ruckInfringements: 0,
            sendOffs: 0,
            sinBins: 0,
            stintOne: 0,
            tackleBreaks: 0,
            tackleEfficiency: 0,
            tacklesMade: 0,
            tries: 0,
            tryAssists: 0,
            twentyFortyKicks: 0
        )
    }
}

