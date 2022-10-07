//
//  MyMatchModel.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/30.
//

import Foundation

struct MyMatch : Codable {
    var matchDate: String
    var myMatchDetail: MyMatchDetail
}

struct MyMatchDetail: Codable {
    var nickname: String
    var matchResult: String
    var goalTotal: Int
    var vsnickname: String
    var vsmatchResult: String
    var vsgoalTotal: Int
}
