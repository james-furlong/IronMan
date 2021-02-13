//
//  PlayerModels.swift
//  
//
//  Created by James Furlong on 9/1/21.
//

import Fluent
import Vapor

final class NRLPlayer: Model, Content {
    struct Public: Content {
        let id: UUID
        let firstName: String
        let lastName: String
        let referenceId: String
        let preferredPosition: NRLPosition
        let actualPosition: NRLPosition
        let currentValue: Double
        let team: NRLTeamEnum
        let values: [NRLValue]
    }
    
    static let schema = "core_nrl_player"
    
    @ID(key: "id") var id: UUID?
    @Field(key: "first_name") var firstName: String
    @Field(key: "last_name") var lastName: String
    @Field(key: "reference_id") var referenceId: String
    @Enum(key: "preferred_position") var preferredPosition: NRLPosition
    @Enum(key: "actual_position") var actualPosition: NRLPosition
    @Field(key: "current_value") var currentValue: Double
    @Enum(key: "team") var team: NRLTeamEnum
    @Field(key: "season") var season: Int
    @Children(for: \.$player) var values: [NRLValue]
    
    init() { }
    
    init(
        id: UUID? = nil,
        firstName: String,
        lastName: String,
        referenceId: String,
        preferredPosition: NRLPosition,
        actualPosition: NRLPosition,
        currentValue: Double,
        team: NRLTeamEnum,
        season: Int
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.referenceId = referenceId
        self.preferredPosition = preferredPosition
        self.actualPosition = actualPosition
        self.currentValue = currentValue
        self.team = team
        self.season = season
    }
}

extension NRLPlayer: Equatable {
    static func == (lhs: NRLPlayer, rhs: NRLPlayer) -> Bool {
        (
            lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.referenceId == rhs.referenceId &&
            lhs.preferredPosition == rhs.preferredPosition &&
            lhs.actualPosition == rhs.actualPosition &&
            lhs.currentValue == rhs.currentValue &&
            lhs.team == rhs.team &&
            lhs.season == rhs.season
        )
    }
}
