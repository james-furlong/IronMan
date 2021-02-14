//
//  UserDetailsModel.swift
//  
//
//  Created by James Furlong on 7/1/21.
//

import Fluent
import Vapor

final class UserDetailsModel: Model {
    struct Public: Content {
        let id: UUID
        let user: User
        let firstName: String
        let lastName: String
        let dob: Date
        let createdAt: Date?
        let updatedAt: Date?
    }
    
    static let schema = "userDetails"
    
    @ID(key: "id") var id: UUID?
    @Parent(key: "user_id") var user: User
    @Field(key: "first_name") var firstName: String
    @Field(key: "last_name") var lastName: String
    @Field(key: "dob") var dob: Date
    @Children(for: \.$user) var teams: [NRLUserTeam]
    @Timestamp(key: "created_at", on: .create) var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update) var updatedAt: Date?
    
    init() { }
    
    init(
        id: UUID? = nil,
        user: User,
        firstName: String,
        lastName: String,
        dob: Date
    ) {
        self.id = id
        self.$user.id = user.id!
        self.firstName = firstName
        self.lastName = lastName
        self.dob = dob
        self.teams = []
    }
}

extension UserDetailsModel {
    static func create(from userDetails: UserDetails, user: User) throws -> UserDetailsModel {
        return UserDetailsModel(
            user: user,
            firstName: userDetails.firstName,
            lastName: userDetails.lastName,
            dob: userDetails.dob
        )
    }
}
