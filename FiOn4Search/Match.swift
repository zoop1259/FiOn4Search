//
//  Match.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/08.
//

import Foundation

struct Match : Codable {
    
    var matchTime: Date // 매칭시간
    var score: Int //골 수
    var id: String //아이디
    var result: String //승패
}
