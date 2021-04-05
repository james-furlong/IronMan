//
//  CreateUserDetails.swift
//  
//
//  Created by James Furlong on 7/1/21.
//

import Fluent

struct CreateUserDetail: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(UserDetailsModel.schema)
            .id()
            .field("user_id", .uuid, .required, .required)
            .foreignKey("user_id", references: User.schema, .id)
            .field("first_name", .string, .required)
            .field("last_name", .string, .required)
            .field("dob", .date, .required)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime, .required)
            .unique(on: "user_id")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(UserDetailsModel.schema).delete()
    }
}
