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
        
        // Admin routes
        let adminProtected = routes.grouped(Token.authenticator(), AdminAuthMiddleware())
        adminProtected.post("admin", use: adminPostUser)
        adminProtected.get("admin", ":user_id", use: adminGetUser)
        adminProtected.patch("admin", "user_id", use: adminPatchUser)
        
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
    
    // MARK: - Admin protected routes
    
    fileprivate func adminPostUser(req: Request) throws -> EventLoopFuture<UserDetailsModel.Public> {
        try AdminUserRequest.validate(content: req)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .none
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        let adminUserSignup: AdminUserRequest = try req.content.decode(AdminUserRequest.self, using: decoder)
        let user = try User.create(from: adminUserSignup.user)
        let userDetails = try UserDetailsModel.create(from: adminUserSignup.details, user: user)
        var token: Token!
        
        return checkIfUserExists(adminUserSignup.user.email, req: req)
            .flatMap { exists in
                guard !exists else { return req.eventLoop.future(error: AdminError.userAlreadyExists) }
                return user.save(on: req.db)
                    .flatMap {
                        userDetails.save(on: req.db)
                    }
            }
            .flatMap {
                guard let newtoken = try? user.createToken(source: .signup) else {
                    return req.eventLoop.future(error: Abort(.internalServerError))
                }
                token = newtoken
                return token.save(on: req.db)
            }
            .flatMapThrowing {
                UserDetailsModel.Public(
                    id: userDetails.id!,
                    user: User.Public(
                        id: user.id!,
                        email: user.email,
                        createdAt: user.createdAt,
                        updatedAt: user.updatedAt
                    ),
                    firstName: userDetails.firstName,
                    lastName: userDetails.lastName,
                    dob: userDetails.dob,
                    createdAt: userDetails.createdAt,
                    updatedAt: userDetails.updatedAt
                )
            }
    }
    
    fileprivate func adminGetUser(req: Request) throws -> EventLoopFuture<Response> {
        let userId = req.parameters.get("user_id", as: UUID.self)
        let userQuery = try User.find(userId, on: req.db).wait()
        guard let user = userQuery else { return req.eventLoop.future(error: Abort(.notFound)) }

        return user.$userDetails.query(on: req.db).first().unwrap(orError: Abort(.notFound))
            .map { details in
                UserDetailsModel.Public(
                    id: details.id!,
                    user: User.Public(
                        id: user.id!,
                        email: user.email,
                        createdAt: user.createdAt,
                        updatedAt: user.updatedAt
                    ),
                    firstName: details.firstName,
                    lastName: details.lastName,
                    dob: details.dob,
                    createdAt: details.createdAt,
                    updatedAt: details.updatedAt
                )
            }
            .encodeResponse(status: .ok, for: req)
    }
    
    fileprivate func adminPatchUser(req: Request) throws -> EventLoopFuture<Response> {
        let userId = req.parameters.get("user_id", as: UUID.self)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .none
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        let data = try req.content.decode(AdminUserRequest.self, using: decoder)
        let userQuery = try User.find(userId, on: req.db).wait()
        let detailsQuery = try UserDetailsModel.find(userQuery?.id, on: req.db).wait()
        
        guard let user = userQuery, let details = detailsQuery else {
            return req.eventLoop.future(error: Abort(.notFound))
        }
        
        user.email = data.user.email
        
        details.firstName = data.details.firstName
        details.lastName = data.details.lastName
        details.dob = data.details.dob
        
        return user.update(on: req.db)
            .flatMap {
                details.update(on: req.db)
            }
            .map {
                UserDetailsModel.Public(
                    id: details.id!,
                    user: User.Public(
                        id: user.id ?? UUID(),
                        email: user.email ?? "",
                        createdAt: user.createdAt,
                        updatedAt: user.updatedAt
                    ),
                    firstName: details.firstName ?? "",
                    lastName: details.lastName ?? "",
                    dob: details.dob ?? Date(),
                    createdAt: details.createdAt,
                    updatedAt: details.updatedAt
                )
                
            }
            .encodeResponse(status: .ok, for: req)
    }

    // MARK: - Views
    fileprivate func create(req: Request) throws -> EventLoopFuture<UserResponse> {
        try UserRequest.validate(content: req)
        let userSignup = try req.content.decode(UserRequest.self)
        let user = try User.create(from: userSignup)
        var token: Token!

        return checkIfUserExists(userSignup.email, req: req)
            .flatMap { exists in
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
                UserResponse(token: token.value, user: try user.asPublic())
            }
    }
    
    fileprivate func login(req: Request) throws -> EventLoopFuture<UserResponse> {
        let user = try req.auth.require(User.self)
        let token = try user.createToken(source: .login)
        
        return token
            .save(on: req.db)
            .flatMapThrowing {
                UserResponse(token: token.value, user: try user.asPublic())
            }
    }
    
    fileprivate func logout(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try UserLogoutRequest.validate(content: req)
        let logoutInfo = try req.content.decode(UserLogoutRequest.self)
        
        return Token.query(on: req.db)
            .filter(\.$value == logoutInfo.token)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    fileprivate func postDetails(req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        let user = try req.auth.require(User.self)
        try UserDetailsRequest.validate(content: req)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .none
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        let userDetails = try req.content.decode(UserDetailsRequest.self, using: decoder)
        
        return UserDetailsModel(
            user: user,
            firstName: userDetails.firstName,
            lastName: userDetails.lastName,
            dob: userDetails.dob
        )
        .create(on: req.db)
        .transform(to: .ok)
    }
    
    fileprivate func getDetails(req: Request) throws -> EventLoopFuture<[UserDetailsRequest]> {
        let _ = try req.auth.require(User.self)
        return UserDetailsModel.query(on: req.db)
            .with(\.$user)
            .all()
            .flatMapThrowing { details in
                details
                    .map { detail in
                        UserDetailsRequest(
                            firstName: detail.firstName,
                            lastName: detail.lastName,
                            dob: detail.dob
                        )
                    }
            }
    }
    
    fileprivate func updateDetails(req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        let user = try req.auth.require(User.self)
        try UserDetailsRequest.validate(content: req)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .none
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        let userDetails = try req.content.decode(UserDetailsRequest.self, using: decoder)
        
        return UserDetailsModel.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .first()
            .flatMapThrowing{ p in
                p?.firstName = userDetails.firstName
                p?.lastName = userDetails.lastName
                p?.dob = userDetails.dob
                
                let _ = p?.update(on: req.db)
            }
            .transform(to: .ok)
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
    
    private func checkIfUserDetailExists(_ details: UserDetailsRequest, req: Request) -> EventLoopFuture<Bool> {
        UserDetailsModel.query(on: req.db)
            .filter(\.$firstName == details.firstName)
            .filter(\.$lastName == details.lastName)
            .filter(\.$dob == details.dob)
            .first()
            .map { $0 != nil }
    }
}
