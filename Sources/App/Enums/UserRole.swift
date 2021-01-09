//
//  File.swift
//  
//
//  Created by James Furlong on 9/1/21.
//

import Fluent

extension FieldKey {
    static var userRole: Self { "userRole" }
}

enum UserRole: String, Codable, CaseIterable {
    static var name: FieldKey { .userRole }
    
    case admin
    case user
}
