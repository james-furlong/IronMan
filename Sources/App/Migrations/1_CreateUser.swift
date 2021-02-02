//
//  File.swift
//  
//
//  Created by James Furlong on 5/1/21.
//

import Fluent

struct CreateUsers: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(User.schema)
      .id()
      .field("email", .string, .required)
      .unique(on: "email")
      .field("password_hash", .string, .required)
      .field("created_at", .datetime, .required)
      .field("updated_at", .datetime, .required)
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(User.schema).delete()
  }
}
