//
//  UserContent.swift
//  
//
//  Created by James Furlong on 7/1/21.
//

import Fluent
import Vapor

// MARK: - User

struct UserRequest: Content, Validatable {
    let email: String
    let password: String
    
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(6...))
    }
}

struct UserDetailsRequest: Content, Validatable {
    let firstName: String
    let lastName: String
    let dob: Date
    
    static func validations(_ validations: inout Validations) {
        validations.add("firstName", as: String.self, is: !.empty)
        validations.add("lastName", as: String.self, is: !.empty)
        validations.add("dob", as: String.self, is: !.empty)
    }
}

struct UserLogoutRequest: Content, Validatable {
    let token: String
    
    static func validations(_ validations: inout Validations) {
        validations.add("token", as: String.self, is: !.empty)
    }
}

struct UserDetailsResponse: Content {
    let userId: UUID
    let firstName: String
    let lastName: String
    let dob: Date
    
    init(from detailModel: UserDetailsModel) {
        self.userId = detailModel.$user.id
        self.firstName = detailModel.firstName
        self.lastName = detailModel.lastName
        self.dob = detailModel.dob
    }
}

struct UserResponse: Content {
    let token: String
    let user: User.Public
}

// MARK: - Admin

struct AdminUserRequest: Content, Validatable {
    let user: UserRequest
    let details: UserDetailsRequest
    
    static func validations(_ validations: inout Validations) {
        validations.add("user", as: UserRequest.self, is: .valid)
        validations.add("details", as: UserDetailsRequest.self, is: .valid)
    }
}
