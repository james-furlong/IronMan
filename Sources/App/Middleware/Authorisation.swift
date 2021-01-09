//
//  File.swift
//  
//
//  Created by James Furlong on 9/1/21.
//

import Fluent
import Vapor

enum AuthRole {
    case User
    case Admin
}

final class AdminAuthMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        do {
            let user = try request.auth.require(User.self)
            if user.userRole != UserRole.admin.rawValue { return request.eventLoop.future(error: Abort(.unauthorized)) }
        }
        catch {
            return request.eventLoop.future(error: Abort(.unauthorized))
        }
        
        return next.respond(to: request)
    }
}

