//
//  UserModel.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/09.
//

import Foundation

struct UserId : Codable {
    
    var accessId: String //전적조회를 위한 엑세스 id
    var level: Int //레벨을 표현하기위해 사용
    
}
