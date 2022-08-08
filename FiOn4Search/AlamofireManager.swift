//
//  AlamofireManager.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/08.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

//func getId() {
//
//    let url = API.BASE_URL
//    AF.request(
//
//}
var searchData = SearchController()
var userSerialNumber = ""
var accessId = ""
var level = 0

func getUserId() {
    /*
     Type      KeyName          Content Type
     Header    Authorization    String
     */
//        let urlString = "https://api.nexon.co.kr/fifaonline4/v1.0/users?nickname=아프리카TV규직"
    let urlString = "https://api.nexon.co.kr/fifaonline4/v1.0/users?nickname="
    
   // guard let data = sear
    
    print("닉네임 : ", userSerialNumber)
    let url = urlString + userSerialNumber
    
    //이게 기본 방식.
//        let headers: HTTPHeaders = [
//            "Content-Type": "String",
//            "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJYLUFwcC1SYXRlLUxpbWl0IjoiNTAwOjEwIiwiYWNjb3VudF9pZCI6IjE0MDkzMDI3MDAiLCJhdXRoX2lkIjoiMiIsImV4cCI6MTY3NDg5NjIxMCwiaWF0IjoxNjU5MzQ0MjEwLCJuYmYiOjE2NTkzNDQyMTAsInNlcnZpY2VfaWQiOiI0MzAwMTE0ODEiLCJ0b2tlbl90eXBlIjoiQWNjZXNzVG9rZW4ifQ.nwgL3AMU216uu88opO2R4br3uMRE1_86V9w0Uh7TbN0"
//            "Accept": "application/json",
//            "Content-Type": "application/json"
//        ]
    
    //그런데 이렇게 해도 된다. 이게 더 이쁜듯...
    let headers: HTTPHeaders = [.authorization("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJYLUFwcC1SYXRlLUxpbWl0IjoiNTAwOjEwIiwiYWNjb3VudF9pZCI6IjE0MDkzMDI3MDAiLCJhdXRoX2lkIjoiMiIsImV4cCI6MTY3NDg5NjIxMCwiaWF0IjoxNjU5MzQ0MjEwLCJuYmYiOjE2NTkzNDQyMTAsInNlcnZpY2VfaWQiOiI0MzAwMTE0ODEiLCJ0b2tlbl90eXBlIjoiQWNjZXNzVG9rZW4ifQ.nwgL3AMU216uu88opO2R4br3uMRE1_86V9w0Uh7TbN0")]
 
//        AF.request(url + searchBar.text!, headers: headers)
//            .responseJSON { response in
//                print(response)
//            }
    AF.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" , method: .get ,headers: headers)
        .responseString { response in
            switch response.result {
            case .success(let res):
                print("res: ", res)
                do {
                    let dataJSON = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let urlList = try JSONDecoder().decode(UserId.self, from: dataJSON)
                    print("액세스 아이디: ",urlList.accessId)
                } catch {
                }


            case .failure(let error):
                print(error)
            }
        }
                
}
    


