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
        let date: Date
        let startingValue: Double
        let finishingValue: Double
        let stats: NRLStat
        let score: Double
    }
    
    @ID(key: "id") var id: UUID?
    @Field(key: "date") var date: Date
    @Field(key: "starting_value") var startingValue: Double
    @Field(key: "finishing_value") var finishingValue: Double
    @Field(key: "score") var score: Double
    @Parent(key: "match") var match: NRLMatch
    @Parent(key: "player") var player: NRLPlayer
    
    static var schema: String { "core_nrl_value" }
    static let startingValue: Double = 125_000.00
    
    init() { }
    
    init(
        id: UUID? = nil,
        date: Date,
        startingValue: Double,
        finishingValue: Double,
        score: Double,
        matchId: UUID,
        playerId: UUID
    ) {
        self.id = id
        self.date = date
        self.startingValue = startingValue
        self.finishingValue = finishingValue
        self.score = score
        self.$match.id = matchId
        self.$player.id = playerId
    }
    
    static func value(from values: [NRLValue], score: Double) -> Double {
        let sortedValues = values.sorted { lhs, rhs in lhs.date > rhs.date }
        // If there is no previous values then we want to return the default value
        // If there is less than 3 values, we can't get an accurate average (without massive jumps) so
        // we return the default value
        if sortedValues.count == 0 || sortedValues.count < 3 {
            return startingValue
        }
        
        // return the value based on the average score
        return [sortedValues.average(\.score)]
            .map { $0 * 100_000.00}
            .first ?? 0.0
    }
}
