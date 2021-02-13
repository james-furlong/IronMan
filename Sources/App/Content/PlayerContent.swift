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
