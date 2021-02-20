//
//  PlayerContent.swift
//  
//
//  Created by James Furlong on 27/1/21.
//

import Fluent
import Vapor

struct NRLPlayersRegister: Content {
    let players: [NRLPlayer]
}

extension NRLPlayersRegister: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("players", as: [NRLPlayer].self, is: !.empty)
    }
}

struct NRLUserPlayerRequest: Content {
    
}

struct NRLUserPlayerResponse: Content {
    let playerId: UUID
    let firstName: String
    let lastName: String
    let team: NRLTeamEnum
    let preferredPosition: NRLPosition
    let actualPosition: NRLPosition
    let scores: [UUID]
    
    init(from userPlayer: NRLUserPlayer, on req: Request) throws {
        let player = try NRLPlayer.find(userPlayer.$player.id, on: req.db).wait()
        self.playerId = (player?.id)!
        self.firstName = (player?.firstName)!
        self.lastName = (player?.lastName)!
        self.team = (player?.team)!
        self.preferredPosition = (player?.preferredPosition)!
        self.actualPosition = userPlayer.position
        self.scores = userPlayer.scores.map { $0.id! }
    }
}
