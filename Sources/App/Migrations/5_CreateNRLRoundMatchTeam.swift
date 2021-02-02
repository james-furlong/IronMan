//
//  File.swift
//  
//
//  Created by James Furlong on 1/2/21.
//

import Fluent

struct CreateNRLRoundMatchTeam: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.enum(NRLMatchMode.name.description)
            .case("Post")
            .case("Pre")
            .case("Mid")
            .create()
            .flatMap { modeEnum in
                database.enum(NRLMatchTeam.name.description)
                    .case("Home")
                    .case("Away")
                    .create()
                    .flatMap { teamEnum in
                        database.enum(NRLMatchState.name.description)
                            .case("Fulltime")
                            .case("Completed")
                            .case("Ongoing")
                            .create()
                            .flatMap { stateEnum in
                                database.schema(NRLRound.schema)
                                    .id()
                                    .field("round", .int, .required)
                                    .field("round_title", .string)
                                    .field("round_start_date_time", .datetime)
                                    .field("round_end_date_time", .datetime)
                                    .field("team_position", .int)
                                    .create()
                                    .flatMap {
                                        database.schema(NRLMatch.schema)
                                            .id()
                                            .field("name", .string, .required)
                                            .field("location", .string, .required)
                                            .field("start_date_time", .datetime)
                                            .field("match_mode", modeEnum, .required)
                                            .field("match_state", stateEnum, .required)
                                            .field("venue", .string, .required)
                                            .field("venue_city", .string, .required)
                                            .field("match_url", .string, .required)
                                            .field("home_team_id", .int, .required)
                                            .field("away_team_id", .int, .required)
                                            .field("round_id", .uuid, .required)
                                            .foreignKey("round_id", references: NRLRound.schema, .id)
                                            .create()
                                            .flatMap {
                                                database.schema(NRLTeam.schema)
                                                    .id()
                                                    .field("stored_id", .int, .required)
                                                    .field("team_name", .string, .required)
                                                    .field("team_nickname", .string, .required)
                                                    .field("team_position", .int)
                                                    .create()
                                            }
                                    }
                            }
                    }
            }
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.flatten([
            database.schema(NRLRound.schema).delete(),
            database.schema(NRLMatch.schema).delete(),
            database.schema(NRLTeam.schema).delete(),
            database.enum(NRLMatchMode.name.description).delete(),
            database.enum(NRLMatchTeam.name.description).delete(),
            database.enum(NRLMatchState.name.description).delete()
        ])
    }
}
