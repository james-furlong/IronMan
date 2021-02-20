//
//  AdminErrors.swift
//  
//
//  Created by James Furlong on 18/2/21.
//

import Vapor

enum AdminError {
    case userAlreadyExists
}

extension AdminError: AbortError {
    var description: String { reason }
    
    var status: HTTPResponseStatus {
        switch self {
            case .userAlreadyExists: return .conflict
        }
    }
    
    var reason: String {
        switch self {
            case .userAlreadyExists: return "User already exists"
        }
    }
}
