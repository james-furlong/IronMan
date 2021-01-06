//
//  UserDetails.swift
//  
//
//  Created by James Furlong on 7/1/21.
//

import Fluent
import Vapor

final class UserDetails: Model {
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
    
    @ID() var id: UUID
    @Parent(key: "user_id") var user: User
    @Field(key: "first_name") var firstName: String
    @Field(key: "last_name") var lastName: String
    @Field(key: "dob") var dob: Date
    @Timestamp(key: "created_at", on: .create) var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update) var updatedAt: Date?
    
    init() { }
    
    init(
        id: UUID = nil,
        userId: User.IDValue,
        firstName: String,
        lastName: String,
        dob: Date
    ) {
        self.id = id
        self.$user.id = userId
        self.firstName = firstName
        self.lastName = lastName
        self.dob = dob
    }
}
