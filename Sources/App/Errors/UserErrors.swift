//
//  UserErrors.swift
//  
//
//  Created by James Furlong on 5/1/21.
//

import Vapor

enum UserError {
    case usernameTaken
    case userDetailRegistered
    case noUserDetailsRegistered
    case insufficientPrivileges
    case userNotFound
}

extension UserError: AbortError {
    var description: String {
        reason
    }

    var status: HTTPResponseStatus {
        switch self {
            case .usernameTaken: return .conflict
            case .userDetailRegistered: return .conflict
            case .noUserDetailsRegistered: return .conflict
            case .insufficientPrivileges: return .unauthorized
            case .userNotFound: return .notFound
        }
    }

    var reason: String {
        switch self {
            case .usernameTaken: return "Username already taken"
            case .userDetailRegistered: return "User details already registered"
            case .noUserDetailsRegistered: return "No user details have been registered"
            case .insufficientPrivileges: return "Insufficient privileges"
            case .userNotFound: return "User not found"
        }
    }
}
