//
//  CreateNRLValueStat.swift
//  
//
//  Created by James Furlong on 2/2/21.
//

import Fluent

struct CreateNRLValueStat: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.flatten([
            database.schema(NRLValue.schema)
                .id()
                .field("date", .date, .required)
                .field("starting_value", .double, .required)
                .field("finishing_value", .double, .required)
                .field("score", .double, .required)
                .field("match", .uuid, .required)
                .foreignKey("match", references: NRLMatch.schema, .id, onDelete: .cascade)
                .field("player", .uuid, .required)
                .foreignKey("player", references: NRLPlayer.schema, .id, onDelete: .cascade)
                .create(),
            database.schema(NRLStat.schema)
                .id()
                .field("value", .uuid, .required)
                .foreignKey("value", references: NRLValue.schema, .id, onDelete: .cascade)
                .unique(on: "value")
                .field("all_run_meters", .int, .required)
                .field("all_runs", .int, .required)
                .field("bomb_kicks", .int, .required)
                .field("cross_field_kicks", .int, .required)
                .field("conversion", .int, .required)
                .field("conversion_attempts", .int, .required)
                .field("dummy_half_runs", .int, .required)
                .field("dummy_half_run_metres", .int, .required)
                .field("dummy_passes", .int, .required)
                .field("errors", .int, .required)
                .field("fantasy_points_total", .int, .required)
                .field("field_goals", .int, .required)
                .field("forced_drop_out_kicks", .int, .required)
                .field("forty_twenty_kicks", .int, .required)
                .field("goals", .int, .required)
                .field("goal_conversion_rate", .double, .required)
                .field("grubber_kicks", .int, .required)
                .field("handling_errors", .int, .required)
                .field("hit_ups", .int, .required)
                .field("hit_up_run_metres", .int, .required)
                .field("ineffective_tackles", .int, .required)
                .field("intercepts", .int, .required)
                .field("kicks", .int, .required)
                .field("kicks_dead", .int, .required)
                .field("kicks_defused", .int, .required)
                .field("kick_metres", .int, .required)
                .field("kick_metres_returned", .int, .required)
                .field("line_break_assists", .int, .required)
                .field("line_breaks", .int, .required)
                .field("line_engaged_runs", .int, .required)
                .field("minutes_played", .int, .required)
                .field("missed_tackles", .int, .required)
                .field("offloads", .int, .required)
                .field("one_on_one_lost", .int, .required)
                .field("one_on_one_steal", .int, .required)
                .field("on_report", .int, .required)
                .field("passes_to_run_ratio", .double, .required)
                .field("passes", .int, .required)
                .field("play_the_ball_total", .int, .required)
                .field("play_the_ball_average_speed", .double, .required)
                .field("penalties", .int, .required)
                .field("points", .int, .required)
                .field("penalty_goals", .int, .required)
                .field("post_contact_metres", .int, .required)
                .field("receipts", .int, .required)
                .field("ruck_infringements", .int, .required)
                .field("send_offs", .int, .required)
                .field("sin_bins", .int, .required)
                .field("stint_one", .int, .required)
                .field("tackle_breaks", .int, .required)
                .field("tackle_efficiency", .double, .required)
                .field("tackles_made", .int, .required)
                .field("tries", .int, .required)
                .field("try_assists", .int, .required)
                .field("twenty_forty_kicks", .int, .required)
                .create()
        ])
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.flatten([
            database.schema(NRLStat.schema).delete(),
            database.schema(NRLValue.schema).delete()
        ])
    }
    
    
}


