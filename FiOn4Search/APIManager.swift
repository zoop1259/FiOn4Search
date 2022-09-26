//
//  CustomError.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/16.
//

//수정해야할 것.
//1. 임시 apikey를 허가받아 새로운 정식 apikey를 얻고 수정해야한다.

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
    
//    Bundle.main.Fifa_API_Key
    
    //발급받은 키
//    private var authorization : String { "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJYLUFwcC1SYXRlLUxpbWl0IjoiNTAwOjEwIiwiYWNjb3VudF9pZCI6IjE0MDkzMDI3MDAiLCJhdXRoX2lkIjoiMiIsImV4cCI6MTY3NDg5NjIxMCwiaWF0IjoxNjU5MzQ0MjEwLCJuYmYiOjE2NTkzNDQyMTAsInNlcnZpY2VfaWQiOiI0MzAwMTE0ODEiLCJ0b2tlbl90eXBlIjoiQWNjZXNzVG9rZW4ifQ.nwgL3AMU216uu88opO2R4br3uMRE1_86V9w0Uh7TbN0"}
    
    private var authorization : String {Bundle.main.Fifa_API_Key}
    
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
    
    //API 적용 여부 --> 이 프로젝트에선 모두 사용해야하지만 나중에 사용하지 않는 프로젝트를 위해
    private var isNeedAPIKey: Bool {
        switch self {
        case .getAccessId, .getTier, .getMatchId, .getMatchInfo:
            return true
        default: //디폴트는 없지만.. 그래도 형식상 씀....나중에 사용하지 않는 api를 위해
            return false
        }
    }
    
    //통신 헤더
    private var header: HTTPHeaders {

        var result = HTTPHeaders([HTTPHeader(name: "Authorization", value: authorization)])
        
//        if isNeedAPIKey {
//            var result = HTTPHeader(name:"Authorization", value: authorization)
//        }
        return result
    }
    
    //Body 파라미터인데 Get으로 예상되어 필요 x
    private var parameter: [String:Any]? {
        switch self {
        case .getAccessId, .getTier, .getMatchId, .getMatchInfo: return nil
        }
    }
 
    

    func request(complete: @escaping ((Result<NSDictionary?,CustomError>)->())) {
        var url = domain
        
        let headers: HTTPHeaders = [.authorization("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJYLUFwcC1SYXRlLUxpbWl0IjoiNTAwOjEwIiwiYWNjb3VudF9pZCI6IjE0MDkzMDI3MDAiLCJhdXRoX2lkIjoiMiIsImV4cCI6MTY3NDg5NjIxMCwiaWF0IjoxNjU5MzQ0MjEwLCJuYmYiOjE2NTkzNDQyMTAsInNlcnZpY2VfaWQiOiI0MzAwMTE0ODEiLCJ0b2tlbl90eXBlIjoiQWNjZXNzVG9rZW4ifQ.nwgL3AMU216uu88opO2R4br3uMRE1_86V9w0Uh7TbN0")]

        //addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed
        if let convertedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) { //.urlPathAllowed 원래는 이거였다
            url += convertedPath
        }
        AF.request(url, method: method, parameters: parameter, headers: headers)
            .responseJSON { response in
                //print(url) //여기서 찾아낸 url에러!
                //print(response.result)
                // 통신 결과 처리
                switch response.result {
                case .success(let dict):
                    // 성공
                    
                    complete(.success(dict as? NSDictionary))
                case .failure:
                    
                    // 결과는 없지만 statusCode에 따라 확인이 필요할 수 있음.
                    if let stCode = response.response?.statusCode, 200..<300 ~= stCode {
                        // 성공
                        complete(.success(nil))
                    } else {
                        // 진짜 실패
                        complete(.failure(.invalidState))
                    }
                }
            }
    }
    
    func request<T: Decodable>(dataType: T.Type, complete: @escaping ((Result<T,CustomError>)->())) {
        
        // 1. 위에 선언한 요청 메소드를 통해 NSDictionary를 받는다.
        request { result in
            //print(result)
            switch result {
            case .success(let dict):
                
                // 2. 데이터 존재 확인
                guard let dicData = dict else {
                    // 데이터 미존재 에러
                    complete(.failure(.invalidData))
                    return
                }
                
                // 3. 얻은 NSDictionary를 JSON 데이터로 바꾼뒤 T형태로 Decode 해준다.
                guard
                    let json = try? JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted),
                    let data = try? JSONDecoder().decode(T.self, from: json)
                else {
                    // 4. Decode실패
                    complete(.failure(.invalidState))
                    return
                }
                
                // 5. T 객체 생성 성공!
                complete(.success(data))
                
            case .failure(let e):
                // 6. Request 실패
                complete(.failure(e))
            }
        }
    }
    
    //배열로 시작하는 경우가 있었기 떄문에 제네릭값을 수정하여 원했던 결과를 받아낸다!
    func arrrequest(complete: @escaping ((Result<Any?,CustomError>)->())) {
//    func arrrequest(complete: @escaping ((Result<NSArray?,CustomError>)->())) {
        var url = domain
        
        let headers: HTTPHeaders = [.authorization("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJYLUFwcC1SYXRlLUxpbWl0IjoiNTAwOjEwIiwiYWNjb3VudF9pZCI6IjE0MDkzMDI3MDAiLCJhdXRoX2lkIjoiMiIsImV4cCI6MTY3NDg5NjIxMCwiaWF0IjoxNjU5MzQ0MjEwLCJuYmYiOjE2NTkzNDQyMTAsInNlcnZpY2VfaWQiOiI0MzAwMTE0ODEiLCJ0b2tlbl90eXBlIjoiQWNjZXNzVG9rZW4ifQ.nwgL3AMU216uu88opO2R4br3uMRE1_86V9w0Uh7TbN0")]

        //addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed
        if let convertedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) { //.urlPathAllowed 원래는 이거였다
            url += convertedPath
        }
        AF.request(url, method: method, parameters: parameter, headers: headers)
            .responseJSON { response in
//                print(url) //여기서 찾아낸 url에러!
                //print(response.result)
                // 통신 결과 처리
                switch response.result {
                case .success(let dict):
                    // 성공
                    let a = dict as? NSDictionary
                    let b = dict as? NSArray
                    //다운캐스팅 실패시 String으로
                    if a == nil && b == nil {
                        complete(.success(dict as? NSString))
                    //딕셔너리 다운캐스팅 실패시 Array로
                    } else if a == nil {
                        complete(.success(dict as? NSArray))
                    //어레이 다운캐스팅 실패시 Dictionary로
                    } else if b == nil {
                        complete(.success(dict as? NSDictionary))
                    }
                    
                case .failure:
                    
                    // 결과는 없지만 statusCode에 따라 확인이 필요할 수 있음.
                    if let stCode = response.response?.statusCode, 200..<300 ~= stCode {
                        // 성공
                        complete(.success(nil))
                        
                    } else {
                        // 진짜 실패
                        complete(.failure(.invalidState))
                    }
                }
            }
    }
    
    func arrrequest<T: Decodable>(dataType: T.Type, complete: @escaping ((Result<T,CustomError>)->())) {
        
        // 1. 위에 선언한 요청 메소드를 통해 NSDictionary를 받는다.
        arrrequest { result in
            //print(result)
            switch result {
            case .success(let dict):
                
                // 2. 데이터 존재 확인
                guard let dicData = dict else {
                    // 데이터 미존재 에러
                    complete(.failure(.invalidData))
                    return
                }
                
                // 3. 얻은 NSDictionary를 JSON 데이터로 바꾼뒤 T형태로 Decode 해준다.
                guard
                    let json = try? JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted),
                    let data = try? JSONDecoder().decode(T.self, from: json)
                else {
                    // 4. Decode실패
                    complete(.failure(.invalidState))
                    return
                }
                
                // 5. T 객체 생성 성공!
                complete(.success(data))
                
            case .failure(let e):
                // 6. Request 실패
                complete(.failure(e))
            }
        }
    }
    
    
//    func apirequest<T: Decodable>(dataType: T.Type, complete: @escaping ((Result<T,CustomError>)->())) {
//
//        // 1. 위에 선언한 요청 메소드를 통해 NSDictionary를 받는다.
//        apirequest(dataType: T.self) { result in
//            switch result {
//            case .success(let dict):
//
//                // 2. 데이터 존재 확인
//    //                guard let dicData = dict else {
//    //                    // 데이터 미존재 에러
//    //                    complete(.failure(.invalidData))
//    //                    return
//    //                }
//
//                // 3. 얻은 NSDictionary를 JSON 데이터로 바꾼뒤 T형태로 Decode 해준다.
//                guard
//                    let json = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                    let data = try? JSONDecoder().decode(T.self, from: json)
//                else {
//                    // 4. Decode실패
//                    complete(.failure(.invalidState))
//                    return
//                }
//
//                // 5. T 객체 생성 성공!
//                complete(.success(data))
//
//            case .failure(let e):
//                // 6. Request 실패
//                complete(.failure(e))
//            }
//        }
//    }
    
}

extension Bundle {
    
    // 생성한 .plist 파일 경로 불러오기
    var Fifa_API_Key: String {
        guard let file = self.path(forResource: "SecretData", ofType: "plist") else { return "" }
        
        // .plist를 딕셔너리로 받아오기
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        // 딕셔너리에서 값 찾기
        guard let key = resource["Fifa_API_Key"] as? String else {
            fatalError("Fifa_API_Key error")
        }
        return key
    }
}
