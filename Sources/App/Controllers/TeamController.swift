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
        
        tokenProtected.get("nrl", use: userTeamGet)
        tokenProtected.post("nrl", use: userTeamPost)
        
        tokenProtected.get("nrl", ":team_id", use: userTeamGet)
        tokenProtected.patch("nrl", ":team_id", use: userTeamPatch)
        // TODO: Add user endpoints

        // Admin protected routes
        let adminProtected = teamRoute.grouped(AdminAuthMiddleware())
        
        adminProtected.get("admin", "nrl", ":user_id", use: adminTeamGetUser)
        adminProtected.post("admin", "nrl", ":user_id", use: adminTeamPostUser)
        adminProtected.patch("admin", "nrl", ":user_id", use: adminTeamPatchUser)
        adminProtected.delete("admin", "nrl", ":user_id", use: adminTeamDeleteUser)
        
        adminProtected.get("admin", "nrl", ":team_id", use: adminTeamGetTeam)
        adminProtected.patch("admin", "nrl", ":team_id", use: adminTeamPatchTeam)
        adminProtected.delete("admin", "nrl", ":team_id", use: adminTeamDeleteTeam)
    }
    
    // MARK: - User routes
    
    fileprivate func userTeamGet(req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.auth.require(User.self)
        
        return NRLUserTeamModel.query(on: req.db).filter(\.$user.$id == user.id!).all()
            .flatMapThrowing { teams -> [NRLUserTeamResponse] in
                var array: [NRLUserTeamResponse] = []
                try teams.forEach { team in
                    array.append( try NRLUserTeamResponse(from: team, on: req))
                }
                
                return array
            }
            .encodeResponse(status: .ok, for: req)
    }
    
    fileprivate func userTeamPost(req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.auth.require(User.self)
        let team = try req.content.decode(NRLUserTeamModel.self)
        
        return NRLUserTeamModel(userId: user.id!, teamName: team.teamName, teamColor: team.teamColor, teamLogo: team.teamLogo)
            .create(on: req.db)
            .flatMapThrowing { _ in
                return try NRLUserTeamResponse(from: team, on: req)
            }
            .encodeResponse(status: .ok, for: req)
    }
    
    fileprivate func userTeamPatch(req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.auth.require(User.self)
        let teamId = req.parameters.get("team_id", as: UUID.self)
        let updateTeam = try req.content.decode(NRLUserTeamModel.self)
        
        return NRLUserTeamModel.find(teamId, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { team in
                if team.$user.id != user.id! {
                    return req.eventLoop.makeFailedFuture(Abort(.badRequest))
                }
                team.teamName = updateTeam.teamName
                team.teamColor = updateTeam.teamColor
                team.teamLogo = updateTeam.teamLogo
                if let id = updateTeam.user.id {
                    team.$user.id = id
                }
                team.players = updateTeam.players
                
                return team.save(on: req.db)
                    .flatMapThrowing { try NRLUserTeamResponse(from: team, on: req) }
                    .encodeResponse(status: .ok, for: req)
            }
    }
    
    // MARK: - Admin routes User ID Routes
    fileprivate func adminTeamGetUser(req: Request) throws -> EventLoopFuture<Response> {
        let _ = try req.auth.require(User.self)
        let userId = req.parameters.get("user_id", as: UUID.self)
        
        return NRLUserTeamModel.query(on: req.db).filter(\.$user.$id == userId!).all()
            .flatMapThrowing { teams -> [NRLUserTeamResponse] in
                var array: [NRLUserTeamResponse] = []
                try teams.forEach { team in
                    array.append(try NRLUserTeamResponse(from: team, on: req))
                }
                
                return array
            }
            .encodeResponse(status: .ok, for: req)
    }
    
    fileprivate func adminTeamPostUser(req: Request) throws ->  EventLoopFuture<Response> {
        let _ = try req.auth.require(User.self)
        let team = try req.content.decode(NRLUserTeamModel.self)
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
            .flatMapThrowing { _ in
                return try NRLUserTeamResponse(from: team, on: req)
            }
            .encodeResponse(status: .ok, for: req)
    }
    
    fileprivate func adminTeamPatchUser(req: Request) throws -> EventLoopFuture<Response> {
        let _ = try req.auth.require(User.self)
        let teamId = req.parameters.get("team_id", as: UUID.self)
        let updateTeam = try req.content.decode(NRLUserTeamModel.self)
        
        return NRLUserTeamModel.find(teamId, on: req.db)
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
                    .flatMapThrowing { try NRLUserTeamResponse(from: team, on: req) }
                    .encodeResponse(status: .ok, for: req)
            }
    }
    
    fileprivate func adminTeamDeleteUser(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let _ = try req.auth.require(User.self)
        let userId = req.parameters.get("user_id", as: UUID.self)
        
        return NRLUserTeamModel.query(on: req.db).filter(\.$user.$id == userId!).first()
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .map { HTTPStatus.ok }
    }
    
    fileprivate func adminTeamGetTeam(req: Request) throws -> EventLoopFuture<Response> {
        let _ = try req.auth.require(User.self)
        let teamId = req.parameters.get("team_id", as: UUID.self)
        
        return NRLUserTeamModel.query(on: req.db).filter(\.$user.$id == teamId!).all()
            .flatMapThrowing { teams -> [NRLUserTeamResponse] in
                var array: [NRLUserTeamResponse] = []
                try teams.forEach { team in
                    array.append(try NRLUserTeamResponse(from: team, on: req))
                }
                
                return array
            }
            .encodeResponse(status: .ok, for: req)
    }
    
    // MARK: - Admin routes Team ID Routes
    fileprivate func adminTeamPatchTeam(req: Request) throws -> EventLoopFuture<Response> {
        let _ = try req.auth.require(User.self)
        let teamId = req.parameters.get("team_id", as: UUID.self)
        let updateTeam = try req.content.decode(NRLUserTeamModel.self)
        
        return NRLUserTeamModel.find(teamId, on: req.db)
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
                    .flatMapThrowing { try NRLUserTeamResponse(from: team, on: req) }
                    .encodeResponse(status: .ok, for: req)
            }
    }
    
    fileprivate func adminTeamDeleteTeam(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let _ = try req.auth.require(User.self)
        let teamId = req.parameters.get("team_id", as: UUID.self)
        
        return NRLUserTeamModel.find(teamId, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .map { HTTPStatus.ok }
    }
}
