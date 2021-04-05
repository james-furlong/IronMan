//
//  AdminAuthMiddleware.swift
//  
//
//  Created by James Furlong on 14/2/21.
//

import Vapor

final class AdminAuthMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        do {
            let tokens = try Token.query(on: request.db).all().wait()
            guard let token: Token = tokens.first(where: { $0.value == request.headers.bearerAuthorization?.token }) else {
                return request.eventLoop.makeFailedFuture(UserError.userNotFound)
            }
            let users = try User.query(on: request.db).all().wait()
            let user: User = users.filter { $0.id == token.$user.id }.first!
            
            if user.accessLevel == .Admin {
                return next.respond(to: request)
            }
        }
        catch {
            return request.eventLoop.makeFailedFuture(UserError.userNotFound)
        }
        
        return request.eventLoop.makeFailedFuture(UserError.insufficientPrivileges)
    }
}
