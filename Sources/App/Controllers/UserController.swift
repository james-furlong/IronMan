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
        tokenProtected.post("details", use: postDetails)
        tokenProtected.get("details", use: getDetails)
        tokenProtected.patch("details", use: updateDetails)
        
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
    
    fileprivate func postDetails(req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        let user = try req.auth.require(User.self)
        try UserDetails.validate(content: req)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .none
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        let userDetails = try req.content.decode(UserDetails.self, using: decoder)
        
        return UserDetailsModel(
            user: user,
            firstName: userDetails.firstName,
            lastName: userDetails.lastName,
            dob: userDetails.dob
        )
        .create(on: req.db)
        .transform(to: .ok)
    }
    
    fileprivate func getDetails(req: Request) throws -> EventLoopFuture<[UserDetails]> {
        let _ = try req.auth.require(User.self)
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
    
    fileprivate func updateDetails(req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        
    }

    func getMyOwnUser(req: Request) throws -> User.Public {
        try req.auth.require(User.self).asPublic()
    }

    //MARK: - Internal functions
    
    private func checkIfUserExists(_ email: String, req: Request) -> EventLoopFuture<Bool> {
        User.query(on: req.db)
            .filter(\.$email == email)
            .first()
            .map { $0 != nil }
    }
    
    private func checkIfUserDetailExists(_ details: UserDetails, req: Request) -> EventLoopFuture<Bool> {
        UserDetailsModel.query(on: req.db)
            .filter(\.$firstName == details.firstName)
            .filter(\.$lastName == details.lastName)
            .filter(\.$dob == details.dob)
            .first()
            .map { $0 != nil }
    }
}
