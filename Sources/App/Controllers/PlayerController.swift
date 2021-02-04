//.
//  File.swift
//  
//
//  Created by James Furlong on 27/1/21.
//

import Fluent
import Vapor

struct PlayerController: RouteCollection {
    
    // MARK: - Routes
    func boot(routes: RoutesBuilder) throws {
        // Unprotected routes
        let playersRoute = routes.grouped("players")
        playersRoute.post("nrl", use: adminPostNrlPlayers)

        // User Auth protected routes
        // TODO: Add user endpoints

        // Admin protected routes
        // TODO: Update this once admin auth has been added
    }

    // MARK: - Views
    fileprivate func adminPostNrlPlayers(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return try req.content
            .decode(NRLPlayersRegister.self)
            .players
            .compactMap { $0.save(on: req.db) }
            .flatten(on: req.eventLoop)
            .map { HTTPStatus.created }
    }
    
    // MARK: - Internal functions
//    private func checkIfPlayerExists(_ player: NRLPlayer, req: Request) -> EventLoopFuture<Bool> {
//        NRLPlayer.query(on: req.db)
//            .filter(\.$lastName == player.lastName)
//            .filter(\.$firstName == player.firstName)
//            .first()
//            .map { $0 != nil }
//    }
}
