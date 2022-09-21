//
//  Search.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/09/21.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class Search {
    
    let searchText = BehaviorRelay<String>(value: "")
//    var searchController = SearchController()
//    
//    //Driver는 에러를 감지하지 않음. 그냥 에러없는 옵저버블이라고 생각하자.
////    let combinedText : Driver<String>
//    
    func obsearch() {
        //searchText = BehaviorRelay<String>
        print("이건 searchText", searchText)
        
        //value를 통해 가져와야 String
        let a = searchText.value
        
        print("Search의 searchText : ",a)
    }
}

/*
 //var accc : String = ""
 //var accc : (String) -> ()?
 //var accc : () -> Void = {}
 
 //////((Result<NSDictionary?,CustomError>)->()))
 func getRequesttest(results: @escaping (String) ->()) {
//    func getRequesttest(completion: @escaping ((String) -> Void)) {
     //엑세스아이디찾기
     let accessid = API.getAccessId(name: self.userNickName)
     accessid.arrrequest(dataType: UserInfo.self) { result in
//            print(result)
         switch result {
         case .success(let dict):
             print("출력해라 \(dict)")
             
             //results = dict.accessId
             results(dict.accessId)
             //self.accc = results
             
         case .failure(let error):
             print("실패받아라", error)
         }

     }
 }
 
 func gettt(results: @escaping ([TierInfo]) ->()) {
     getRequesttest(results: { str in
         print("함수내부",str)
         let tier = API.getTier(accessId: str)
         tier.arrrequest(dataType: [TierInfo].self) { tierresult in
             switch tierresult {
             case .success(let tierInfo):
                 results(tierInfo)
                 print("이렇게 티어를 받아보자",tierInfo)
                 
                 
             case .failure(let error):
                 print("티어 실패받아라", error)
             }
         }
     })
 }
 
 
 
 */
