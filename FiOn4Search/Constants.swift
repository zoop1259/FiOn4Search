//
//  Constants.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/08.
//

import Foundation

enum API {
    //기본 url
    static let BASE_URL : String = "https://api.nexon.co.kr/fifaonline4/v1.0/"
    
    //api key
    static let Authorization : String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJYLUFwcC1SYXRlLUxpbWl0IjoiNTAwOjEwIiwiYWNjb3VudF9pZCI6IjE0MDkzMDI3MDAiLCJhdXRoX2lkIjoiMiIsImV4cCI6MTY3NDg5NjIxMCwiaWF0IjoxNjU5MzQ0MjEwLCJuYmYiOjE2NTkzNDQyMTAsInNlcnZpY2VfaWQiOiI0MzAwMTE0ODEiLCJ0b2tlbl90eXBlIjoiQWNjZXNzVG9rZW4ifQ.nwgL3AMU216uu88opO2R4br3uMRE1_86V9w0Uh7TbN0"
    
    /*
     Type      KeyName          Content Type
     Header    Authorization    String
     */
    
}

enum NOTIFICATION {
    enum API {
        static let AUTH_FAIL = "authentication_fail"
    }
}
