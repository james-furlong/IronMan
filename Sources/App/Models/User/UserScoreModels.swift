//
//  UserScoreModels.swift
//  
//
//  Created by James Furlong on 14/2/21.
//

import Vapor
import Fluent

final class NRLUserScore: Model, Content {
    struct Public {
        let id: UUID
        let value: NRLValue
        let position: NRLPosition
        let modifiedScore: Double
        let unmodifiedScore: Double
        let modifier: Double
    }
    
    static var schema: String = "user_nrl_score"
    
    @ID(key: "id") var id: UUID?
    @Parent(key:"value") var value: NRLValue
    @Parent(key: "user_player") var userPlayer: NRLUserPlayer
    @Enum(key: "position") var position: NRLPosition
    @Field(key: "modified_score") var modifiedScore: Double
    @Field(key: "unmodified_score") var unmodifiedScore: Double
    @Field(key: "modifier") var modifier: Double
    
    init() { }
    
    init(
        id: UUID? = nil,
        valueId: UUID,
        playerId: UUID,
        position: NRLPosition,
        modifiedScore: Double,
        unmodifiedScore: Double,
        modifier: Double
    ) {
        self.id = id
        self.$value.id = valueId
        self.$userPlayer.id = playerId
        self.position = position
        self.modifiedScore = modifiedScore
        self.unmodifiedScore = unmodifiedScore
        self.modifier = modifier
    }
}
