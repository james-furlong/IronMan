//
//  TeamContent.swift
//  
//
//  Created by James Furlong on 18/2/21.
//

import Fluent
import Vapor

struct NRLUserTeamRequest: Content {
    let teamName: String
    let teamColor: String
    let teamLogo: Int
    let players: [NRLUserPlayerRequest]
}

struct NRLUserTeamResponse: Content {
    let user: UserDetailsResponse
    let teamName: String
    let teamColor: String
    let teamLogo: Int
    let players: [NRLUserPlayerResponse]
    
    init(from userTeam: NRLUserTeamModel, on req: Request) throws {
        self.user = UserDetailsResponse(from: userTeam.user)
        self.teamName = userTeam.teamName
        self.teamColor = userTeam.teamColor
        self.teamLogo = userTeam.teamLogo
        self.players = try userTeam.players.map { try NRLUserPlayerResponse(from: $0, on: req) }
    }
}
