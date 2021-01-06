//
//  File.swift
//  
//
//  Created by James Furlong on 5/1/21.
//

import Vapor
import Fluent

struct UserSignup: Content {
  let email: String
  let password: String
}

struct UserLogout: Content {
    let token: String
}

struct NewSession: Content {
    let token: String
    let user: User.Public
}

extension UserSignup: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: !.empty)
        validations.add("password", as: String.self, is: .count(6...))
    }
}

extension UserLogout: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("token", as: String.self, is: !.empty)
    }
}

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("users")
        usersRoute.post("signup", use: create)
        
        let tokenProtected = usersRoute.grouped(Token.authenticator())
        tokenProtected.get("me", use: getMyOwnUser)
        
        let passwordProtected = usersRoute.grouped(User.authenticator())
        passwordProtected.post("login", use: login)
        passwordProtected.post("logout", use: logout)
    }

    fileprivate func create(req: Request) throws -> EventLoopFuture<NewSession> {
        try UserSignup.validate(content: req)
        let userSignup = try req.content.decode(UserSignup.self)
        let user = try User.create(from: userSignup)
        var token: Token!

        return checkIfUserExists(userSignup.email, req: req).flatMap { exists in
            guard !exists else {
                return req.eventLoop.future(error: UserError.usernameTaken)
            }

            return user.save(on: req.db)
        }
        .flatMap {
            guard let newToken = try? user.createToken(source: .signup) else {
                return req.eventLoop.future(error: Abort(.internalServerError))
            }
            token = newToken
            return token.save(on: req.db)
        }
        .flatMapThrowing {
            NewSession(token: token.value, user: try user.asPublic())
        }
    }
    
    fileprivate func login(req: Request) throws -> EventLoopFuture<NewSession> {
        let user = try req.auth.require(User.self)
        let token = try user.createToken(source: .login)
        
        return token
            .save(on: req.db)
            .flatMapThrowing {
                NewSession(token: token.value, user: try user.asPublic())
            }
    }
    
    fileprivate func logout(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try UserLogout.validate(content: req)
        let logoutInto = try req.content.decode(UserLogout.self)
        
        return Token.query(on: req.db)
            .filter(\.$value == logoutInto.token)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }

    func getMyOwnUser(req: Request) throws -> User.Public {
        try req.auth.require(User.self).asPublic()
    }

    private func checkIfUserExists(_ email: String, req: Request) -> EventLoopFuture<Bool> {
        User.query(on: req.db)
            .filter(\.$email == email)
            .first()
            .map { $0 != nil }
    }
}
