//
//  File.swift
//  
//
//  Created by James Furlong on 14/2/21.
//

import Vapor
import Fluent

final class NRLUserTeam: Model, Content {
    struct Public {
        let id: UUID
        let teamName: String
        let teamColor: String
        let teamLogo: Int
        let players: [NRLPlayer]
    }
}
