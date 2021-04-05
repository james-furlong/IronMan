//
//  UserPlayerModels.swift
//  
//
//  Created by James Furlong on 14/2/21.
//

import Vapor
import Fluent

final class NRLUserPlayer: Model, Content {
    struct Public: Content {
        let id: UUID
        let playerId: UUID
        let name: String
        let position: NRLPosition
        let scores: [NRLUserScore.Public]
    }
    
    static var schema: String = "user_nrl_player"
    
    @ID(key: "id") var id: UUID?
    @Parent(key: "player") var player: NRLPlayer
    @Parent(key: "team") var team: NRLUserTeamModel
    @Enum(key: "position") var position: NRLPosition
    @Children(for: \.$userPlayer) var scores: [NRLUserScore]
    
    init() { }
    
    init(
        id: UUID? = nil,
        playerId: UUID,
        teamId: UUID,
        position: NRLPosition
    ) {
        self.id = id
        self.$player.id = playerId
        self.$team.id = teamId
        self.position = position
        self.scores = []
    }
}
