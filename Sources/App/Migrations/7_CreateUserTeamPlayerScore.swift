//
//  File.swift
//  
//
//  Created by James Furlong on 14/2/21.
//

import Fluent

struct CreataUserTeamPlayerScore: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.enum(NRLPosition.name.description)
            .case("Hooker")
            .case("Prop")
            .case("Second-Rower")
            .case("Lock")
            .case("Half-Back")
            .case("Five-Eighth")
            .case("Center")
            .case("Winger")
            .case("Fullback")
            .case("Bench")
            .case("Reserve")
            .case("Coach")
            .create()
            .flatMap { positionEnum in
                database.eventLoop.flatten([
                    database.schema(NRLUserTeam.schema)
                        .id()
                        .field("user", .uuid, .required)
                        .foreignKey("user", references: UserDetailsModel.schema, .id)
                        .field("team_name", .string, .required)
                        .field("team_color", .string, .required)
                        .field("team_logo", .int, .required)
                        .create(),
                    database.schema(NRLUserPlayer.schema)
                        .id()
                        .field("player", .uuid, .required)
                        .foreignKey("player", references: NRLPlayer.schema, .id)
                        .field("team", .uuid, .required)
                        .foreignKey("team", references: NRLUserTeam.schema, .id)
                        .field("position", positionEnum, .required)
                        .create(),
                    database.schema(NRLUserScore.schema)
                        .id()
                        .field("value", .uuid, .required)
                        .foreignKey("value", references: NRLValue.schema, .id)
                        .field("user_player", .uuid, .required)
                        .foreignKey("user_player", references: NRLUserPlayer.schema, .id)
                        .field("position", positionEnum, .required)
                        .field("modified_score", .double, .required)
                        .field("unmodified_score", .double, .required)
                        .field("modifier", .double, .required)
                        .create()
                ])
            }
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.flatten([
            database.schema(NRLUserTeam.schema).delete(),
            database.schema(NRLUserPlayer.schema).delete(),
            database.schema(NRLUserScore.schema).delete()
        ])
    }
}
