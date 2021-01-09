//
//  File.swift
//  
//
//  Created by James Furlong on 9/1/21.
//

import Fluent
import Vapor

struct AdminUser: Migration {
    let userName = "admin@sportico.com"
    let password = "$2b$12$0YtUGG/lSQfxKx4HCT.tUufWepqTt2TJovfJ/SiwGrDlH7PokmdMO"
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return User(
            email: userName,
            passwordHash: password,
            userRole: .admin
        ).create(on: database)
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        User.query(on: database).filter(\.$email == userName).delete()
    }
}
