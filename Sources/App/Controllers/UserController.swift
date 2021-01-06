//
//  File.swift
//  
//
//  Created by James Furlong on 5/1/21.
//

import Vapor
import Fluent

struct UserController: RouteCollection {
    
    // MARK: - Routes
    func boot(routes: RoutesBuilder) throws {
        // Unprotected routes
        let usersRoute = routes.grouped("users")
        usersRoute.post("signup", use: create)
        usersRoute.post("logout", use: logout)
        
        // User Auth protected routes
        let tokenProtected = usersRoute.grouped(Token.authenticator())
        tokenProtected.get("me", use: getMyOwnUser)
        tokenProtected.put("details", use: putDetails)
        tokenProtected.get("details", use: getDetails)
        
        // Password protected routes
        let passwordProtected = usersRoute.grouped(User.authenticator())
        passwordProtected.post("login", use: login)
    }

    // MARK: - Views
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
        let logoutInfo = try req.content.decode(UserLogout.self)
        
        return Token.query(on: req.db)
            .filter(\.$value == logoutInfo.token)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    fileprivate func putDetails(req: Request) throws -> EventLoopFuture<UserDetails> {
        let user = try req.auth.require(User.self)
        try UserDetails.validate(content: req)
        let userDetails = try req.content.decode(UserDetails.self)
        let details = try UserDetailsModel.create(from: userDetails, userId: user.id!)
        
        return details
            .save(on: req.db)
            .flatMapThrowing {
                UserDetails(firstName: details.firstName, lastName: details.lastName, dob: details.dob)
            }
    }
    
    fileprivate func getDetails(req: Request) throws -> EventLoopFuture<[UserDetails]> {
        return UserDetailsModel.query(on: req.db)
            .with(\.$user)
            .all()
            .flatMapThrowing { details in
                details
                    .map { detail in
                        UserDetails(
                            firstName: detail.firstName,
                            lastName: detail.lastName,
                            dob: detail.dob
                        )
                    }
            }
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
