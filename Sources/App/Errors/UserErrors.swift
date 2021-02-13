//
//  File.swift
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
            case .insufficientPrivileges: return .conflict
        }
    }

    var reason: String {
        switch self {
            case .usernameTaken: return "Username already taken"
            case .userDetailRegistered: return "User details already registered"
            case .noUserDetailsRegistered: return "No user details have been registered"
            case .insufficientPrivileges: return "Insufficient privileges"
        }
    }
}
