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
            let user = try request.auth.require(User.self)
            if user.accessLevel == .Admin {
                return next.respond(to: request)
            }
        }
        catch {}
        
        return request.eventLoop.makeFailedFuture(UserError.insufficientPrivileges)
    }
}
