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
        let playerNumber: Int
        let preferredPosition: NRLPosition
        let actualPosition: NRLPosition
        let currentValue: Int
        let team: NRLTeamEnum
        let values: [NRLValue]
    }
    
    static let schema = "core_nrl_player"
    
    @ID(key: "id") var id: UUID?
    @Field(key: "first_name") var firstName: String
    @Field(key: "last_name") var lastName: String
    @Field(key: "number") var number: Int
    @Enum(key: "preferred_position") var preferredPosition: NRLPosition
    @Enum(key: "actual_position") var actualPosition: NRLPosition
    @Field(key: "current_value") var value: Int
    @Enum(key: "team") var team: NRLTeamEnum
    @Field(key: "season") var season: Int
    @Children(for: \.$player) var values: [NRLValue]
    
    init() { }
    
    init(
        id: UUID? = nil,
        firstName: String,
        lastName: String,
        playerNumber: Int,
        preferredPosition: NRLPosition,
        actualPosition: NRLPosition,
        value: Int,
        team: NRLTeamEnum,
        season: Int
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.number = playerNumber
        self.preferredPosition = preferredPosition
        self.actualPosition = actualPosition
        self.value = value
        self.team = team
        self.season = season
    }
}
