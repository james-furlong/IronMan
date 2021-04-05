//
//  PlayerContent.swift
//  
//
//  Created by James Furlong on 27/1/21.
//

import Fluent
import Vapor

// MARK: -  User content

struct NRLPlayersRegister: Content {
    let players: [NRLPlayer]
}

extension NRLPlayersRegister: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("players", as: [NRLPlayer].self, is: !.empty)
    }
}

struct NRLUserPlayersRequest: Content {
    let teamId: UUID
}

struct NRLUserPlayersResponse: Content {
    let players: [NRLUserPlayerResponse]
}

struct NRLUserPlayerRequest: Content {
    let position: NRLPosition
    let team: UUID // NRLUserTeam.Id
}

struct NRLUserPlayerResponse: Content {
    let playerId: UUID
    let firstName: String
    let lastName: String
    let team: NRLTeamEnum
    let preferredPosition: NRLPosition
    let actualPosition: NRLPosition
    let scores: [UUID]
    
    init(from userPlayer: NRLUserPlayer) {
        let player = userPlayer.player
        self.playerId = player.id!
        self.firstName = player.firstName
        self.lastName = player.lastName
        self.team = player.team
        self.preferredPosition = player.preferredPosition
        self.actualPosition = userPlayer.position
        self.scores = userPlayer.scores.map { $0.id! }
    }
    
    init(
        playerId: UUID,
        firstName: String,
        lastName: String,
        team: NRLTeamEnum,
        preferredPosition: NRLPosition,
        actualPosition: NRLPosition,
        scores: [UUID]
    ) {
        self.playerId = playerId
        self.firstName = firstName
        self.lastName = lastName
        self.team = team
        self.preferredPosition = preferredPosition
        self.actualPosition = actualPosition
        self.scores = scores
    }
}

struct NRLUserPlayerUpdateResponse: Content {
    let playerId: UUID
    let firstName: String
    let lastName: String
    let team: NRLTeamEnum
    let preferredPosition: NRLPosition
    let actualPosition: NRLPosition
    
    init(player: NRLUserPlayer) {
        self.playerId = player.id!
        self.firstName = player.player.firstName
        self.lastName = player.player.lastName
        self.team = player.player.team
        self.preferredPosition = player.player.preferredPosition
        self.actualPosition = player.position
    }
}

// MARK: - Admin conten

struct NRLAdminPlayersResponse: Content {
    let teams: [NRLUserTeamModel.Public]
}
