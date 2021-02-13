//
//  ResultContent.swift
//  
//
//  Created by James Furlong on 5/2/21.
//

import Fluent
import Vapor

struct NRLResultsRegister: Content {
    let results: [NRLResult.Public]
}

extension NRLResultsRegister: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("results", as: [NRLResult.Public].self, is: !.empty)
    }
}
