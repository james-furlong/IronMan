//
//  File.swift
//  
//
//  Created by James Furlong on 14/2/21.
//

import Vapor
import Fluent

struct TeamController: RouteCollection {
    
    // MARK: - Routes
    func boot(routes: RoutesBuilder) throws {
        // Unprotected routes
        let teamRoute = routes.grouped("team")

        // User Auth protected routes
        let tokenProtected = teamRoute.grouped(Token.authenticator())
        tokenProtected.post("nrl", use: userTeamPost)
        tokenProtected.patch("nrl", ":team_id", use: userTeamPatch)
        // TODO: Add user endpoints

        // Admin protected routes
        let adminProtected = teamRoute.grouped(AdminAuthMiddleware())
        adminProtected.post("nrl", ":user_id", use: adminTeamPost)
        adminProtected.patch("nrl", ":team_id", use: adminTeamPatch)
        adminProtected.delete("nrl", ":team_id", use: adminTeamDelete)
    }
    
    // MARK: - User routes
    
    fileprivate func userTeamPost(req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.auth.require(User.self)
        let team = try req.content.decode(NRLUserTeam.self)
        
        return NRLUserTeam(userId: user.id!, teamName: team.teamName, teamColor: team.teamColor, teamLogo: team.teamLogo)
            .create(on: req.db)
            .map { _ in
                return NRLUserTeamResponse(id: team.id!, teamName: team.teamName, teamColor: team.teamColor, teamLogo: team.teamLogo, players: team.players)
            }
            .encodeResponse(status: .ok, for: req)
    }
    
    fileprivate func userTeamPatch(req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.auth.require(User.self)
        let teamId = req.parameters.get("team_id", as: UUID.self)
        let updateTeam = try req.content.decode(NRLUserTeam.self)
        
        return NRLUserTeam.find(teamId, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { team in
                team.teamName = updateTeam.teamName
                team.teamColor = updateTeam.teamColor
                team.teamLogo = updateTeam.teamLogo
                if let id = updateTeam.user.id {
                    team.$user.id = id
                }
                team.players = updateTeam.players
                
                return team.save(on: req.db)
                    .map { NRLUserTeamResponse(id: team.id!, teamName: team.teamName, teamColor: team.teamColor, teamLogo: team.teamLogo, players: team.players) }
                    .encodeResponse(status: .ok, for: req)
            }
    }
    
    // MARK: - Admin routes
    
    fileprivate func adminTeamPost(req: Request) throws ->  EventLoopFuture<Response> {
        let _ = try req.auth.require(User.self)
        let team = try req.content.decode(NRLUserTeam.self)
        let userId = req.parameters.get("user_id", as: UUID.self)!
        
        return UserDetailsModel.query(on: req.db).filter(\.$id == userId)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { _ in
                req.eventLoop.flatten([
                    team.create(on: req.db),
                    req.eventLoop.flatten(
                        team.players
                            .map { player in
                                player.create(on: req.db)
                            }
                    )
                ])
            }
            .map { _ in
                return NRLUserTeamResponse(id: team.id!, teamName: team.teamName, teamColor: team.teamColor, teamLogo: team.teamLogo, players: team.players)
            }
            .encodeResponse(status: .ok, for: req)
    }
    
    fileprivate func adminTeamPatch(req: Request) throws -> EventLoopFuture<Response> {
        let _ = try req.auth.require(User.self)
        let teamId = req.parameters.get("team_id", as: UUID.self)
        let updateTeam = try req.content.decode(NRLUserTeam.self)
        
        return NRLUserTeam.find(teamId, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { team in
                team.teamName = updateTeam.teamName
                team.teamColor = updateTeam.teamColor
                team.teamLogo = updateTeam.teamLogo
                if let id = updateTeam.user.id {
                    team.$user.id = id
                }
                team.players = updateTeam.players
                
                return team.save(on: req.db)
                    .map { NRLUserTeamResponse(id: team.id!, teamName: team.teamName, teamColor: team.teamColor, teamLogo: team.teamLogo, players: team.players) }
                    .encodeResponse(status: .ok, for: req)
            }
            
    }
    
    fileprivate func adminTeamDelete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let _ = try req.auth.require(User.self)
        let teamId = req.parameters.get("team_id", as: UUID.self)
        
        return NRLUserTeam.find(teamId, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .map { HTTPStatus.ok }
    }
}
