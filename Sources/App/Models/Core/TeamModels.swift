//
//  TeamModels.swift
//  
//
//  Created by James Furlong on 1/2/21.
//

import Fluent
import Vapor

final class NRLTeam: Model, Content {
    struct Public: Content {
        let id: UUID
        let storedId: Int
        let teamName: String?
        let teamNickname: String
        let teamPosition: Int?
    }
    
    static let schema = "core_nrl_team"
    
    @ID(key: "id") var id: UUID?
    @Field(key: "stored_id") var storedId: Int
    @Field(key: "team_name") var teamName: String
    @Field(key: "team_nickname") var teamNickname: String
    @Field(key: "team_position") var teamPosition: Int?
    
    init() { }
    
    init(
        id: UUID? = nil,
        storedId: Int,
        teamName: String,
        teamNickname: String,
        teamPosition: Int? = nil
    ) {
        self.id = id
        self.storedId = storedId
        self.teamName = teamName
        self.teamNickname = teamNickname
        self.teamPosition = teamPosition
    }
}
