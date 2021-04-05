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
        let playersRoute = routes.grouped("players", "nrl")
        
        // Admin protected routes
        let adminProtected = playersRoute.grouped(AdminAuthMiddleware())
        adminProtected.get("admin", use: adminGetNrlPlayers)
        adminProtected.post("admin", use: adminPostNrlPlayers)
        adminProtected.patch("admin", ":player_id", use: adminPatchNrlPlayer)

        // User Auth protected routes
        let tokenProtected = playersRoute.grouped(Token.authenticator())
        tokenProtected.get(use: userGetNrlPlayers)
        tokenProtected.patch(":player_id", use: userPatchNrlPlayer)
    }

    // MARK: - Admin routes
    
    fileprivate func adminGetNrlPlayers(req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.auth.require(User.self)
        let details = try UserDetailsModel.find(user.id, on: req.db).wait()
        
        return details!.$teams.get(on: req.db)
            .map { teams in
                return NRLAdminPlayersResponse(
                    teams: teams.map { team in
                        NRLUserTeamModel.Public(
                            id: team.id!,
                            userId: user.id!,
                            team_name: team.teamName,
                            team_color: team.teamColor,
                            team_logo: team.teamLogo,
                            players: team.players.map { player in
                                NRLUserPlayer.Public(
                                    id: player.id!,
                                    playerId: player.player.id!,
                                    name: player.player.firstName,
                                    position: player.position,
                                    scores: player.scores.map { score in
                                        NRLUserScore.Public(
                                            id: score.id!,
                                            valueId: score.value.id!,
                                            position: score.position,
                                            modifiedScore: score.modifiedScore,
                                            unmodifiedScore: score.unmodifiedScore,
                                            modifier: score.modifier
                                        )
                                    }
                                )
                            }
                        )
                    }
                )
            }
            .encodeResponse(status: .ok, for: req)
    }
    
    fileprivate func adminPostNrlPlayers(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return try req.content
            .decode(NRLPlayersRegister.self)
            .players
            .compactMap { $0.save(on: req.db) }
            .flatten(on: req.eventLoop)
            .map { HTTPStatus.created }
    }
    
    fileprivate func adminPatchNrlPlayer(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let newDetails = try req.content.decode(NRLUserPlayerRequest.self)
        let playerId = req.parameters.get("player_id", as: UUID.self)
        
        return NRLUserPlayer.find(playerId, on: req.db)
            .unwrap(orError: Abort(.notFound))
            .flatMap { player in
                NRLUserTeamModel.find(newDetails.team, on: req.db)
                    .unwrap(or: Abort(.notFound))
                    .flatMap { team in
                        player.team = team
                        player.position = newDetails.position

                        return player.update(on: req.db)
                    }
            }
            .map { HTTPStatus.ok }
    }
    
    // MARK: - User routes
    
    fileprivate func userGetNrlPlayers(req: Request) throws -> EventLoopFuture<Response> {
        let _ = try req.auth.require(User.self)
        let data = try req.content.decode(NRLUserPlayersRequest.self)
        
        return NRLUserTeamModel.find(data.teamId, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { team in
                team.$players.get(on: req.db)
            }
            .map { players in
                NRLUserPlayersResponse(
                    players: players.map { player in
                        NRLUserPlayerResponse(from: player)
                    }
                )
            }
            .encodeResponse(status: .ok, for: req)
    }
    
    fileprivate func userPatchNrlPlayer(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let _ = try req.auth.require(User.self)
        let newDetails = try req.content.decode(NRLUserPlayerRequest.self)
        let playerId = req.parameters.get("player_id", as: UUID.self)
        
        return NRLUserPlayer.find(playerId, on: req.db)
            .unwrap(orError: Abort(.notFound))
            .flatMap { player in
                NRLUserTeamModel.find(newDetails.team, on: req.db)
                    .unwrap(or: Abort(.notFound))
                    .flatMap { team in
                        player.team = team
                        player.position = newDetails.position

                        return player.update(on: req.db)
                    }
            }
            .map { HTTPStatus.ok }
    }
}
