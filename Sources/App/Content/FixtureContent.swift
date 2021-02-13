//
//  FixtureContent.swift
//  
//
//  Created by James Furlong on 4/2/21.
//

import Fluent
import Vapor

struct NRLFixtureRegister: Content {
    let rounds: [NRLRound.Public]
}

extension NRLFixtureRegister: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("rounds", as: [NRLRound].self, is: !.empty)
    }
}
