//
//  MyTierModel.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/09/02.
//

import Foundation

struct SoloTier : Codable {
    let soloTierName : String
    let soloTierUrl : String
    let soloTierTime : String
}

struct DuoTier : Codable {
    let duoTierName : String
    let duoTierUrl : String
    let duoTierTime : String
}
