//
//  FixtureController.swift
//  
//
//  Created by James Furlong on 4/2/21.
//

import Fluent
import Vapor

struct FixtureController: RouteCollection {
    
    // MARK: - Routes
    func boot(routes: RoutesBuilder) throws {
        // Unprotected routes
        let fixturesRoute = routes.grouped("fixture")

        // User Auth protected routes
        let tokenProtected = fixturesRoute.grouped(Token.authenticator())
        // TODO: Add user endpoints

        // Admin protected routes
        let adminProtected = fixturesRoute.grouped(AdminAuthMiddleware())
        adminProtected.post("nrl", use: adminPostNrlFixture)
    }

    // MARK: - Views
    fileprivate func adminPostNrlFixture(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return try req.content
            .decode(NRLFixtureRegister.self)
            .rounds
            .map { round in
                let newRound = NRLRound(from: round)
                return newRound
                    .create(on: req.db)
                    .flatMap { createdRound in
                        var eventLoops: [EventLoopFuture<Void>] = []
                        round.matches.forEach { match in
                            let newMatch = NRLMatch(from: match, roundId: newRound.id!)
                            eventLoops.append(newMatch.create(on: req.db))
                        }
                        return req.eventLoop.flatten(eventLoops)
                    }
            }
            .flatten(on: req.eventLoop)
            .map  { HTTPStatus.created }
    }
}
