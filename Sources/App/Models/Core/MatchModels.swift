//
//  MatchModels.swift
//  
//
//  Created by James Furlong on 1/2/21.
//

import Fluent
import Vapor

final class NRLMatch: Model, Content {
    struct Public: Content {
        let id: UUID
        let name: String
        let location: String
        let startDateTime: Date?
        let matchMode: NRLMatchMode
        let matchState: NRLMatchState
        let venue: String
        let venueCity: String
        let matchUrl: String
        let homeTeamId: Int
        let awayTeamId: Int
    }
    
    static let schema: String = "core_nrl_match"
    
    @ID(key: "id") var id: UUID?
    @Field(key: "name") var name: String
    @Field(key: "location") var location: String
    @Field(key: "start_date_time") var startDateTime: Date?
    @Enum(key: "match_mode") var matchMode: NRLMatchMode
    @Enum(key: "match_state") var matchState: NRLMatchState
    @Field(key: "venue") var venue: String
    @Field(key: "venueCity") var venueCity: String
    @Field(key: "match_url") var matchUrl: String
    @Field(key: "home_team_id") var homeTeamId: Int
    @Field(key: "away_team_id") var awayTeamId: Int
    @Parent(key: "round_id") var round: NRLRound
    
    init() { }
    
    init(
        id: UUID? = nil,
        name: String,
        location: String,
        startDateTime: Date?,
        matchMode: NRLMatchMode,
        matchState: NRLMatchState,
        venue: String,
        venueCity: String,
        matchUrl: String,
        homeTeamId: Int,
        awayTeamId: Int,
        round_id: UUID
    ) {
        self.id = id
        self.name = name
        self.location = location
        self.startDateTime = startDateTime
        self.matchMode = matchMode
        self.matchState = matchState
        self.venue = venue
        self.venueCity = venueCity
        self.matchUrl = matchUrl
        self.homeTeamId = homeTeamId
        self.awayTeamId = awayTeamId
        self.$round.id = round_id
    }
}

extension FieldKey {
    static var nrlMatchMode: Self { "nrlMatchMode" }
    static var nrlMatchTeam: Self { "nrlMatchTeam" }
    static var nrlMatchState: Self { "nrlMatchState" }
}

enum NRLMatchMode: String, Codable, CaseIterable {
    static var name: FieldKey { .nrlMatchMode }
    
    case Post
    case Pre
    case Mid
}

enum NRLMatchTeam: String, Codable, CaseIterable {
    static var name: FieldKey { .nrlMatchTeam }
    
    case Home
    case Away
}

enum NRLMatchState: String, Codable, CaseIterable {
    static var name: FieldKey { .nrlMatchState }
    
    case Fulltime
    case Upcoming
    case Ongoing
}
