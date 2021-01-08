//
//  File.swift
//  
//
//  Created by James Furlong on 9/1/21.
//

import Fluent
import Vapor

final class Player: Model {
    struct Public: Content {
        let id: UUID
        let firstName: String
        let lastName: String
        let playerNumber: Int
        let preferredPosition: Position
        let actualPosition: Position
        let value: Int
        let team: NRLTeam
    }
    
    static let schema = "player"
    
    @ID(key: "id") var id: UUID?
    @Field(key: "first_name") var firstName: String
    @Field(key: "last_name") var lastName: String
    @Field(key: "number") var number: Int
    @Field(key: "preferred_position") var preferredPosition: Position
    @Field(key: "actual_position") var actualPosition: Position
    @Field(key: "value") var value: Int
    @Field(key: "team") var team: NRLTeam
    
    init() { }
    
    init(
        id: UUID? = nil,
        firstName: String,
        lastName: String,
        playerNumber: Int,
        preferredPosition: Position,
        actualPosition: Position,
        value: Int,
        team: NRLTeam
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.number = playerNumber
        self.preferredPosition = preferredPosition
        self.actualPosition = actualPosition
        self.value = value
        self.team = team
    }
}
