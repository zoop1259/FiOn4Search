//
//  MyMatchModel.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/30.
//

import Foundation

struct MyMatch : Codable {
    var matchDate: String
//    var nickname: String //전적조회를 위한 엑세스 id
//    var matchResult: String
//    var goalTotal: Int
    var myMatchDetail: MyMatchDetail
//    let data: [String: SkillData]
//    var matchData: [String: MyMatchDetail]
    
}

struct MyMatchDetail: Codable {
    var nickname: String
    var matchResult: String
    var goalTotal: Int
    var vsnickname: String
    var vsmatchResult: String
    var vsgoalTotal: Int
}

/*
 let matchDate = matchresult.matchDate // 매칭날짜
 //2. Match에서 matchInfo에서 nickname
 let matchInfoma = matchresult.matchInfo
 
 for infoma in matchInfoma {
     let nickName = infoma.nickname // 닉네임
 //3. Match에서 matchInfo에서 matchDetail에서 matchResult
     let matchDetail = infoma.matchDetail
     let matchResult = matchDetail.matchResult //승패
 //4. Match에서 matchInfo에서 shoot에서 goalTotal //몇대몇
     let shoots = infoma.shoot
     let goal = shoots.goalTotal //골.
 */
