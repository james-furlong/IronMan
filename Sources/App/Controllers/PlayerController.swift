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

        // User Auth protected routes
        let tokenProtected = playersRoute.grouped(Token.authenticator())
        // TODO: Add user endpoints

        // Admin protected routes
        let adminProtected = playersRoute.grouped(AdminAuthMiddleware())
        adminProtected.post("nrl", use: adminPostNrlPlayers)
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
}
