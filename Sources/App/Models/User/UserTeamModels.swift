//
//  UserTeamModels.swift
//  
//
//  Created by James Furlong on 14/2/21.
//

import Vapor
import Fluent

final class NRLUserTeamModel: Model{
    static var schema: String = "user_nrl_team"
    
    @ID(key: "id") var id: UUID?
    @Parent(key: "user") var user: UserDetailsModel
    @Field(key: "team_name") var teamName: String
    @Field(key: "team_color") var teamColor: String
    @Field(key: "team_logo") var teamLogo: Int
    @Children(for: \.$team) var players: [NRLUserPlayer]
    
    init() { }
    
    init(
        id: UUID? = nil,
        userId: UUID,
        teamName: String,
        teamColor: String,
        teamLogo: Int
    ) {
        self.id = id
        self.$user.id = userId
        self.teamName = teamName
        self.teamColor = teamColor
        self.teamLogo = teamLogo
        self.players = []
    }
}

extension NRLUserTeamModel {
    static func create(from request: NRLUserTeamRequest, user: User) throws -> NRLUserTeamModel {
        return NRLUserTeamModel(
            userId: user.id!,
            teamName: request.teamName,
            teamColor: request.teamColor,
            teamLogo: request.teamLogo
        )
    }
}

//extension UserDetailsModel {
//    static func create(from userDetails: UserDetailsRequest, user: User) throws -> UserDetailsModel {
//        return UserDetailsModel(
//            user: user,
//            firstName: userDetails.firstName,
//            lastName: userDetails.lastName,
//            dob: userDetails.dob
//        )
//    }
//}

//final class NRLUserTeamResponse: Content {
//    let id: UUID
//    let teamName: String
//    let teamColor: String
//    let teamLogo: Int
//    let players: [NRLUserPlayer]
//
//    init(
//        id: UUID,
//        teamName: String,
//        teamColor: String,
//        teamLogo: Int,
//        players: [NRLUserPlayer]
//    ) {
//        self.id = id
//        self.teamName = teamName
//        self.teamColor = teamColor
//        self.teamLogo = teamLogo
//        self.players = players
//    }
//}
