//
//  TierModel.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/09.
//

import Foundation

// MARK: - WelcomeElement
struct TierInfo: Codable {
    let matchType, division: Int
    let achievementDate: String
}

typealias Tier  = [TierInfo]
