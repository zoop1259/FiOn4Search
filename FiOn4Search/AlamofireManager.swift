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

class AlamofireManager {
    public static let shared = AlamofireManager()

    func AFPokemos(success: @escaping ((UserInfo) -> Void),
                    fail: @escaping (() -> Void)) {
        
        ServiceManager.shared.AFService(urlString: "https://pokeapi.co/api/v2/pokemon/") { (response: UserInfo) in success(response)
        } fail : {
            fail()
        }
    }

}



/*
var search = SearchController()

let baseUrl = "https://api.nexon.co.kr/fifaonline4/v1.0/users"
let tierUrl = baseUrl + "/\(search.accessId)/maxdivision"

//let tierUrl = "https://api.nexon.co.kr/fifaonline4/v1.0/users/eb70ee1d2d036a119ec6682c/maxdivision"
/*
 [
         {
                 "matchType": 50,
                 "division": 800,
                 "achievementDate": "2020-08-23T12:39:59"
         },
         {
                 "matchType": 52,
                 "division": 900,
                 "achievementDate": "2021-02-01T19:00:57"
         }
 ]
 */
let urlString = "https://api.nexon.co.kr/fifaonline4/v1.0/users?nickname="
/*
 {
         "accessId": "eb70ee1d2d036a119ec6682c",
         "nickname": "아프리카TV규직",
         "level": 1583
 }
 */

let matchId = "https://api.nexon.co.kr/fifaonline4/v1.0/users/eb70ee1d2d036a119ec6682c/matches?matchtype=50&offset=0&limit=10"
/*
 [ //offset이 최근경기 //limit 최근경기 몇경기?
         "62f11f9b948c1e080f85055b",
         "62f11d26e19d9d86cf78fc40",
         "62f119fcb84fd533db451bcb",
         "62f0eaecca720e6218e2eeb6",
         "62f0e5f655df3e4cd0fe5016",
         "62f0e3646703ac900db4f9ea",
         "62f0e0df14f42d1bbe8f3d51",
         "62f0de5158cc5450aef5c463",
         "62f0d6520a11bb1c41554e81",
         "62f0d3498d6342ce627f1ad0"
 ]
 */

 let matchInfo = "https://api.nexon.co.kr/fifaonline4/v1.0/matches/62f11f9b948c1e080f85055b"
 //길어 이건 정보가;;;
 
//그런데 이렇게 해도 된다. 이게 더 이쁜듯...
let headers: HTTPHeaders = [.authorization("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJYLUFwcC1SYXRlLUxpbWl0IjoiNTAwOjEwIiwiYWNjb3VudF9pZCI6IjE0MDkzMDI3MDAiLCJhdXRoX2lkIjoiMiIsImV4cCI6MTY3NDg5NjIxMCwiaWF0IjoxNjU5MzQ0MjEwLCJuYmYiOjE2NTkzNDQyMTAsInNlcnZpY2VfaWQiOiI0MzAwMTE0ODEiLCJ0b2tlbl90eXBlIjoiQWNjZXNzVG9rZW4ifQ.nwgL3AMU216uu88opO2R4br3uMRE1_86V9w0Uh7TbN0")]









var searchData = SearchController()
var userNickName = ""

func getUserId() {
    var userSerialNumber = ""
    var accessId = ""
    var level = 0

    
    /*
     Type      KeyName          Content Type
     Header    Authorization    String
     */
//        let urlString = "https://api.nexon.co.kr/fifaonline4/v1.0/users?nickname=아프리카TV규직"
    let urlString = "https://api.nexon.co.kr/fifaonline4/v1.0/users?nickname="
    
   // guard let data = sear
    
    print("닉네임 : ", userNickName)
    let url = urlString + userNickName
    
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
        .responseJSON { response in
            switch response.result {
            case .success(let res):
                //print("res: ", res)
                do {
                    let dataJSON = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let urlList = try JSONDecoder().decode(UserInfo.self, from: dataJSON)
                    //print("액세스 아이디: ",urlList.accessId)
                    accessId = urlList.accessId
                    level = urlList.level
            
                    searchData.nameLabel.text! = "\(userNickName)  \(urlList.level)"
                    print(searchData.nameLabel.text)

                } catch {
                    print("아이디가 없습니다.")
                }
                
            case .failure(let error):
                print(error)
            }
            //여기까진 데이터가 남는군.
            print("과연 밖에서도 데이터가 연결될까? :", accessId)
        }
    //여기선 데이터 증발
}
*/


