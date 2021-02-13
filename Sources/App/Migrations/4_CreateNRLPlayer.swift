//
//  File.swift
//  
//
//  Created by James Furlong on 29/1/21.
//

import Fluent

struct CreateNRLPlayer: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.enum("position")
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
            .flatMap { position in
                database.enum("nrl_team")
                    .case ("brisbaneBronos")
                    .case ("canberraRaiders")
                    .case ("canterburyBankstownBulldogs")
                    .case ("cronullSutherlandSharks")
                    .case ("goldCoastTitans")
                    .case ("manlyWarringahSeaEagles")
                    .case ("melbourneStorm")
                    .case ("newcastleKnights")
                    .case ("newZealandWarriors")
                    .case ("northQueenslandCowboys")
                    .case ("parramattaEels")
                    .case ("penrithPanthers")
                    .case ("southSydneyRabbitohs")
                    .case ("stGeorgeIllawarraDragons")
                    .case ("sydneyRoosters")
                    .case ("westTigers")
                    .create()
                    .flatMap { team in
                        database.schema(NRLPlayer.schema)
                            .id()
                            .field("first_name", .string, .required)
                            .field("last_name", .string, .required)
                            .field("reference_id", .string, .required)
                            .field("preferred_position", position, .required)
                            .field("actual_position", position, .required)
                            .field("current_value", .double)
                            .field("team", team, .required)
                            .field("season", .int, .required)
                            .create()
                    }
            }
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(NRLPlayer.schema).delete().flatMap { _ in
            database.enum("position").delete().flatMap{
                database.enum("nrl_team").delete()
            }
        }
    }
}
