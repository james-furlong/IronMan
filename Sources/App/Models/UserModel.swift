//
//  File.swift
//  
//
//  Created by James Furlong on 5/1/21.
//

import Fluent
import Vapor

final class User: Model {
    struct Public: Content {
        let email: String
        let id: UUID
        let createdAt: Date?
        let updatedAt: Date?
    }
  
    static let schema = "users"
  
    @ID(key: "id") var id: UUID?
    @Field(key: "email") var email: String
    @Field(key: "password_hash") var passwordHash: String
    @Children(for: \.$user) var userDetails: [UserDetailsModel]
    @Timestamp(key: "created_at", on: .create) var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update) var updatedAt: Date?
  
    init() {}
  
    init(id: UUID? = nil, email: String, passwordHash: String) {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
    }
}

extension User {
    static func create(from userSignup: UserSignup) throws -> User {
        User(email: userSignup.email, passwordHash: try Bcrypt.hash(userSignup.password))
    }
    
    func createToken(source: SessionSource) throws -> Token {
        let calendar = Calendar(identifier: .gregorian)
        let expiryDate: Date = calendar.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        
        return try Token(userId: requireID(),
                         token: [UInt8].random(count: 16).base64,
                         source: source,
                         expiresAt: expiryDate
        )
    }
    
    func createUserDetails(details: UserDetails, user: User) throws -> UserDetailsModel {
        return try UserDetailsModel(
            user: user,
            firstName: details.firstName,
            lastName: details.lastName,
            dob: details.dob
        )
    }

    func asPublic() throws -> Public {
        Public(email: email,
               id: try requireID(),
               createdAt: createdAt,
               updatedAt: updatedAt)
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$passwordHash
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}
