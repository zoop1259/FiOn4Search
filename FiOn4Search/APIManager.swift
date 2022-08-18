//
//  CustomError.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/16.
//

import Foundation
import Alamofire

let baseUrl = "https://api.nexon.co.kr/fifaonline4/v1.0/"

enum CustomError: Error {
    case invalidState // 유효하지 않은 statuscode
    case invalidUrl   // URL 없음
    case invalidData  // 데이터 없음.
}


enum API {
    case getAccessId(name: String)
    case getTier(accessId: String)
    //count가 0이면 최근경기부터 , limit는 몇경기를 받아올 것인가.
    case getMatchId(accessId: String, limit: Int)
    case getMatchInfo(matchId: String)
}

extension API {
    
    //발급받은 키
    private var authorization : String { "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJYLUFwcC1SYXRlLUxpbWl0IjoiNTAwOjEwIiwiYWNjb3VudF9pZCI6IjE0MDkzMDI3MDAiLCJhdXRoX2lkIjoiMiIsImV4cCI6MTY3NDg5NjIxMCwiaWF0IjoxNjU5MzQ0MjEwLCJuYmYiOjE2NTkzNDQyMTAsInNlcnZpY2VfaWQiOiI0MzAwMTE0ODEiLCJ0b2tlbl90eXBlIjoiQWNjZXNzVG9rZW4ifQ.nwgL3AMU216uu88opO2R4br3uMRE1_86V9w0Uh7TbN0"}
    
    //메인? 도메인
    private var domain: String {
        switch self {
        case .getAccessId:
            return baseUrl
        case .getTier:
            return baseUrl
        case .getMatchId:
            return baseUrl
        case .getMatchInfo:
            return baseUrl
        }
    }
    
    //URL완성시키기
    private var path: String {
        //스위치 셀프는 자기자신의 enum들을 가리킨다.
        switch self {
        case .getAccessId(name: let name):
            return "users?nickname=\(name)"
        case .getTier(accessId: let accessId):
            return "users/\(accessId)/maxdivision"
        case .getMatchId(accessId: let accessId, limit: let limit):
            return "users/\(accessId)/matches?matchtype=50&offset=0&limit=\(limit)"
        case .getMatchInfo(matchId: let matchId):
            return "matches/\(matchId)"
        }
    }
    
    //HTTP메소드 정의
    private var method: Alamofire.HTTPMethod {
        switch self {
        case .getAccessId, .getTier, .getMatchId, .getMatchInfo:
            return .get
        }
    }
    
    
    
}


let headers: HTTPHeaders = [.authorization("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJYLUFwcC1SYXRlLUxpbWl0IjoiNTAwOjEwIiwiYWNjb3VudF9pZCI6IjE0MDkzMDI3MDAiLCJhdXRoX2lkIjoiMiIsImV4cCI6MTY3NDg5NjIxMCwiaWF0IjoxNjU5MzQ0MjEwLCJuYmYiOjE2NTkzNDQyMTAsInNlcnZpY2VfaWQiOiI0MzAwMTE0ODEiLCJ0b2tlbl90eXBlIjoiQWNjZXNzVG9rZW4ifQ.nwgL3AMU216uu88opO2R4br3uMRE1_86V9w0Uh7TbN0")]
