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
                print(url) //여기서 찾아낸 url에러!
                print(response.result)
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
    
    func arrrequest(complete: @escaping ((Result<NSArray?,CustomError>)->())) {
        var url = domain
        
        let headers: HTTPHeaders = [.authorization("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJYLUFwcC1SYXRlLUxpbWl0IjoiNTAwOjEwIiwiYWNjb3VudF9pZCI6IjE0MDkzMDI3MDAiLCJhdXRoX2lkIjoiMiIsImV4cCI6MTY3NDg5NjIxMCwiaWF0IjoxNjU5MzQ0MjEwLCJuYmYiOjE2NTkzNDQyMTAsInNlcnZpY2VfaWQiOiI0MzAwMTE0ODEiLCJ0b2tlbl90eXBlIjoiQWNjZXNzVG9rZW4ifQ.nwgL3AMU216uu88opO2R4br3uMRE1_86V9w0Uh7TbN0")]

        //addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed
        if let convertedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) { //.urlPathAllowed 원래는 이거였다
            url += convertedPath
        }
        AF.request(url, method: method, parameters: parameter, headers: headers)
            .responseJSON { response in
                print(url) //여기서 찾아낸 url에러!
                print(response.result)
                // 통신 결과 처리
                switch response.result {
                case .success(let dict):
                    // 성공
                    
                    complete(.success(dict as? NSArray))
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

/*
 본문을 참조하여 제가 사용하는 모델에 맞게 코드를 작성해보았습니다.
 작성도중 NS딕셔너리를 이용한 클로저는 정상적으로 작동이 됐습니다.
 그런데..제네릭을 이용한 클로저에서 오류가 발생했습니다.
 func request<T: Decodable>(dataType: T.Type, complete: @escaping ((Result<T,NetworkError>)->())) {
  
     // 1. 위에 선언한 요청 메소드를 통해 NSDictionary를 받는다.
     request { result in     // <- 여기서 dataType관련하여 에러가 발생했습니다.

 바보처럼 (dataType: T.self) 이렇게 작성하고
 2번부분을 주석처리한후
 3번의 dictata를 dict로 변경하니

 에러가 발생한 라인에서 'function call causes an infinite recursion' 에러가 발생했습니다.

 역시나 실행했더니 동작이 멈췄습니다.

 제네릭과 escaping에 대해서 복습하고왔지만 아직도 원인을 모르겠습니다..
 */
