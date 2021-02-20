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
        let id: UUID
        let email: String
        let createdAt: Date?
        let updatedAt: Date?
    }
    
    enum AccessLevel: String, Codable, CaseIterable {
        static var name: FieldKey { .accessLevel }
        case User
        case Admin
    }
  
    static let schema = "users"
  
    @ID(key: "id") var id: UUID?
    @Field(key: "email") var email: String
    @Field(key: "password_hash") var passwordHash: String
    @Enum(key: "access_level") var accessLevel: AccessLevel
    @Children(for: \.$user) var userDetails: [UserDetailsModel] // TODO: Change to a one-to-one relationship
    @Timestamp(key: "created_at", on: .create) var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update) var updatedAt: Date?
  
    init() {}
  
    init(id: UUID? = nil, email: String, passwordHash: String, accessLevel: AccessLevel) {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
        self.accessLevel = accessLevel
    }
}

extension User {
    static func create(from userSignup: UserRequest) throws -> User {
        User(email: userSignup.email, passwordHash: try Bcrypt.hash(userSignup.password), accessLevel: .User)
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
    
    func createUserDetails(details: UserDetailsRequest, user: User) throws -> UserDetailsModel {
        return try UserDetailsModel(
            user: user,
            firstName: details.firstName,
            lastName: details.lastName,
            dob: details.dob
        )
    }

    func asPublic() throws -> Public {
        Public(id: try requireID(),
               email: email,
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

extension FieldKey {
    static var accessLevel: Self { "accessLevel" }
}
