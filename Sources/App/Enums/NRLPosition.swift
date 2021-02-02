//
//  File.swift
//  
//
//  Created by James Furlong on 9/1/21.
//

import Fluent

extension FieldKey {
    static var nrlPosition: Self { "nrlPosition "}
}

enum NRLPosition: String, Codable, CaseIterable {
    static var name: FieldKey { .nrlPosition }
    
    case hooker = "Hooker"
    case prop = "Prop"
    case secondRower = "Second-Rower"
    case lock = "Lock"
    case halfback = "Half-Back"
    case fiveEigth = "Five-Eighth"
    case center = "Center"
    case winger = "Winger"
    case fullback = "Fullback"
    case bence = "Bench"
    case reserve = "Reserve"
    case coach = "Coach"
}
