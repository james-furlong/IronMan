//
//  ResultController.swift
//
//
//  Created by James Furlong on 5/2/21.
//

import Fluent
import Vapor

struct ResultController: RouteCollection {
    
    // MARK: - Routes
    func boot(routes: RoutesBuilder) throws {
        // Unprotected routes
        let resultsRoute = routes.grouped("result")

        // User Auth protected routes
        let tokenProtected = resultsRoute.grouped(Token.authenticator())
        // TODO: Add user endpoints

        // Admin protected routes
        let adminProtected = resultsRoute.grouped(AdminAuthMiddleware())
        adminProtected.post("nrl", use: adminPostNrlResults)
    }

    // MARK: - Views
    fileprivate func adminPostNrlResults(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return try req.content
            .decode(NRLResultsRegister.self)
            .results
            .compactMap { nrlResult in
                return NRLMatch.query(on: req.db)
                    .filter( \.$referenceId == nrlResult.matchReferenceId)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .flatMap { match in
                        return NRLResult.find(match.id, on: req.db)
                            .unwrap(orReplace: NRLResult(from: nrlResult, matchId: match.id!))
                            .flatMap { result in
                                return req.eventLoop.flatten([
                                    result.save(on: req.db)] +
                                    nrlResult.stats.map { stat in
                                        NRLPlayer.query(on: req.db)
                                            .filter(\.$referenceId == stat.playerReferenceId)
                                            .first()
                                            .unwrap(or: Abort(.notFound))
                                            .flatMap { player in
                                                NRLValue.query(on: req.db)
                                                    .join(NRLPlayer.self, on: \NRLValue.$player.$id == \NRLPlayer.$id)
                                                    .all()
                                                    .flatMap { values in
                                                        let startingValue = values.sorted { $0.match.startDateTime ?? Date() < $1.match.startDateTime ?? Date() }.first?.startingValue
                                                        let score: Double = NRLStat.score(from: stat)
                                                        let finishingValue = NRLValue.value(from: values, score: score)
                                                        let newValue = NRLValue(
                                                            date: match.startDateTime ?? Date(),
                                                            startingValue: startingValue ?? NRLValue.startingValue,
                                                            finishingValue: finishingValue,
                                                            score: score,
                                                            matchId: match.id!,
                                                            playerId: player.id!
                                                        )
                                                        let _ = newValue.save(on: req.db)
                                                        
                                                        let newStat = NRLStat(from: stat, valueId: newValue.id!)
                                                        return newStat.save(on: req.db)
                                                    }


                                            }
                                    }
                                )
                            }
                    }
            }
            .flatten(on: req.eventLoop)
            .map { _ in HTTPStatus.created }
    }
}
