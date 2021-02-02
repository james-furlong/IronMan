//
//  RoundModels.swift
//  
//
//  Created by James Furlong on 1/2/21.
//

import Fluent
import Vapor

final class NRLRound: Model, Content {
    struct Public: Content {
        let id: UUID
        var round: Int
        let roundTitle: String?
        let roundStartDateTime: Date?
        let roundEndDateTime: Date?
        var matches: [NRLMatch]
    }
    
    static let schema: String = "core_nrl_round"
    
    @ID(key: "id") var id: UUID?
    @Field(key: "round") var round: Int
    @Field(key: "round_title") var roundTitle: String?
    @Field(key: "round_start_date_time") var roundStartDateTime: Date?
    @Field(key: "round_end_date_time") var roundEndDateTime: Date?
    @Children(for: \.$round) var matches: [NRLMatch]
    
    init() { }
    
    init(
        id: UUID? = nil,
        round: Int,
        roundTitle: String? = nil,
        roundStartDateTime: Date? = nil,
        roundEndDateTime: Date? = nil
    ) {
        self.id = id
        self.round = round
        self.roundTitle = roundTitle
        self.roundStartDateTime = roundStartDateTime
        self.roundEndDateTime = roundEndDateTime
    }
}
