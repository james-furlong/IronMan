//
//  File.swift
//  
//
//  Created by James Furlong on 5/2/21.
//

import Fluent
import Vapor

final class NRLResult: Model, Content {
    struct Public: Content {
        let id: UUID? = nil
        let matchReferenceId: String
        let score: String
        let gameSeconds: Int
        let homeScore: Int
        let homeHalfTimeScore: Int
        let awayScore: Int
        let awayHalfTimeScore: Int
        let homeTries: Int
        let awayTries: Int
        let homeConversions: Int
        let awayConversions: Int
        let homeConversionAttempts: Int
        let awayConversionAttempts: Int
        let homePenaltyGoals: Int
        let awayPenaltyGoals: Int
        let homePenaltyGoalAttempts: Int
        let awayPenaltyGoalAttempts: Int
        let homeFieldGoals: Int
        let awayFieldGoals: Int
        let homeFieldGoalAttempts: Int
        let awayFieldGoalAttempts: Int
        let homeSinBins: Int
        let awaySinBins: Int
        let homeSendOffs: Int
        let awaySendOffs: Int
        let stats: [NRLStat.Public]
    }
    
    static let schema: String = "core_nrl_result"
    
    @ID(key: "id") var id: UUID?
    @Field(key: "score") var score: String
    @Field(key: "games_seconds") var gameSeconds: Int
    @Field(key: "home_score") var homeScore: Int
    @Field(key: "home_half_time_score") var homeHalfTimeScore: Int
    @Field(key: "away_score") var awayScore: Int
    @Field(key: "away_half_time_score") var awayHalfTimeScore: Int
    @Field(key: "home_tries") var homeTries: Int
    @Field(key: "away_tries") var awayTries: Int
    @Field(key: "home_conversions") var homeConversions: Int
    @Field(key: "away_conversions") var awayConversions: Int
    @Field(key: "home_conversion_attempts") var homeConversionAttempts: Int
    @Field(key: "away_conversion_attempts") var awayConversionAttempts: Int
    @Field(key: "home_penalty_goals") var homePenaltyGoals: Int
    @Field(key: "away_penalty_goals") var awayPenaltyGoals: Int
    @Field(key: "home_penalty_goal_attempts") var homePenaltyGoalAttempts: Int
    @Field(key: "away_penalty_goal_attempts") var awayPenaltyGoalAttempts: Int
    @Field(key: "home_field_goals") var homeFieldGoals: Int
    @Field(key: "away_field_goals") var awayFieldGoals: Int
    @Field(key: "home_field_goal_attempts") var homeFieldGoalAttempts: Int
    @Field(key: "away_field_goal_attempts") var awayFieldGoalAttempts: Int
    @Field(key: "home_sin_bins") var homeSinBins: Int
    @Field(key: "away_sin_bins") var awaySinBins: Int
    @Field(key: "home_send_offs") var homeSendOffs: Int
    @Field(key: "away_send_offs") var awaySendOffs: Int
    @Parent(key: "match") var match: NRLMatch
    
    init() { }
    
    init(from result: NRLResult.Public, id: UUID? = nil, matchId: UUID) {
        self.id = id != nil ? id : result.id
        self.$match.id = matchId
        self.score = result.score
        self.gameSeconds = result.gameSeconds
        self.homeScore = result.homeScore
        self.homeHalfTimeScore = result.homeHalfTimeScore
        self.awayScore = result.awayScore
        self.awayHalfTimeScore = result.awayHalfTimeScore
        self.homeTries = result.homeTries
        self.awayTries = result.awayTries
        self.homeConversions = result.homeConversions
        self.awayConversions = result.awayConversions
        self.homeConversionAttempts = result.homeConversionAttempts
        self.awayConversionAttempts = result.awayConversionAttempts
        self.homePenaltyGoals = result.homePenaltyGoals
        self.awayPenaltyGoals = result.awayPenaltyGoals
        self.homePenaltyGoalAttempts = result.homePenaltyGoalAttempts
        self.awayPenaltyGoalAttempts = result.awayPenaltyGoalAttempts
        self.homeFieldGoals = result.homeFieldGoals
        self.awayFieldGoals = result.awayFieldGoals
        self.homeFieldGoalAttempts = result.homeFieldGoalAttempts
        self.awayFieldGoalAttempts = result.awayFieldGoalAttempts
        self.homeSinBins = result.homeSinBins
        self.awaySinBins = result.awaySinBins
        self.homeSendOffs = result.homeSendOffs
        self.awaySendOffs = result.awaySendOffs
    }
}
