//
//  MatchInfoModel.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/09.
//

import Foundation

// MARK: - Welcome
struct Match: Codable {
    let matchID, matchDate: String
    let matchInfo: [MatchInfo]

    enum CodingKeys: String, CodingKey {
        case matchID = "matchId"
        case matchDate, matchInfo
    }
}

// MARK: - MatchInfo
struct MatchInfo: Codable {
    let accessID, nickname: String
    let matchDetail: MatchDetail
    let shoot: Shoot

    enum CodingKeys: String, CodingKey {
        case accessID = "accessId"
        case nickname, matchDetail, shoot
    }
}

// MARK: - MatchDetail
struct MatchDetail: Codable {
    let matchResult, controller: String
}

// MARK: - Shoot
struct Shoot: Codable {
    let goalTotal: Int
}
