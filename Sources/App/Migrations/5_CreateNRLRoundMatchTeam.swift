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
                            .case("Upcoming")
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
                                            .field("reference_id", .string, .required)
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
                                                    .flatMap {
                                                        database.schema(NRLResult.schema)
                                                            .id()
                                                            .field("match", .uuid, .required)
                                                            .foreignKey("match", references: NRLMatch.schema, .id, onDelete: .cascade, onUpdate: .noAction)
                                                            .field("score", .string, .required)
                                                            .field("games_seconds", .int, .required)
                                                            .field("home_score", .int, .required)
                                                            .field("home_half_time_score", .int, .required)
                                                            .field("away_score", .int, .required)
                                                            .field("away_half_time_score", .int, .required)
                                                            .field("home_tries", .int, .required)
                                                            .field("away_tries", .int, .required)
                                                            .field("home_conversions", .int, .required)
                                                            .field("away_conversions", .int, .required)
                                                            .field("home_conversion_attempts", .int, .required)
                                                            .field("away_conversion_attempts", .int, .required)
                                                            .field("home_penalty_goals", .int, .required)
                                                            .field("away_penalty_goals", .int, .required)
                                                            .field("home_penalty_goal_attempts", .int, .required)
                                                            .field("away_penalty_goal_attempts", .int, .required)
                                                            .field("home_field_goals", .int, .required)
                                                            .field("away_field_goals", .int, .required)
                                                            .field("home_field_goal_attempts", .int, .required)
                                                            .field("away_field_goal_attempts", .int, .required)
                                                            .field("home_sin_bins", .int, .required)
                                                            .field("away_sin_bins", .int, .required)
                                                            .field("home_send_offs", .int, .required)
                                                            .field("away_send_offs", .int, .required)
                                                            .create()
                                                    }
                                            }
                                    }
                            }
                    }
            }
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.flatten([
            database.schema(NRLResult.schema).delete(),
            database.schema(NRLTeam.schema).delete(),
            database.schema(NRLMatch.schema).delete(),
            database.schema(NRLRound.schema).delete(),
            database.enum(NRLMatchState.name.description).delete(),
            database.enum(NRLMatchTeam.name.description).delete(),
            database.enum(NRLMatchMode.name.description).delete()
        ])
    }
}
