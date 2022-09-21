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

//닉네임과 매치디테일 그리고 골수.
//0. Match //공통
//1. Match에서 matchDate //매칭날짜
//2. Match에서 matchInfo에서 nickname //닉네임
//3. Match에서 matchInfo에서 matchDetail에서 matchResult //승패
//5. Match에서 matchInfo에서 shoot에서 goalTotal //몇대몇
