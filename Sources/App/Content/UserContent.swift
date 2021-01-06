//
//  UserContent.swift
//  
//
//  Created by James Furlong on 7/1/21.
//

import Fluent
import Vapor

struct UserSignup: Content {
  let email: String
  let password: String
}

struct UserDetails: Content {
    let firstName: String
    let lastName: String
    let dob: Date
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

extension UserDetails: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("firstName", as: String.self, is: !.empty)
        validations.add("lastName", as: String.self, is: !.empty)
        validations.add("dob", as: Date.self, is: .valid)
    }
}

extension UserLogout: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("token", as: String.self, is: !.empty)
    }
}
