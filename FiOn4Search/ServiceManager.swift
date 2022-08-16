//
//  ServiceManager.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/16.
//

import Foundation
import Alamofire

class ServiceManager {
    public static let shared = ServiceManager()

    func reciveNick(Nick: String) {
        
    }
    
    
    
    func AFService<T: Decodable>(urlString: String,
                                 success: @escaping ((T) -> Void),
                                 fail: @escaping (() -> Void)) {
    //        let url = URL(string: urlString)
    
        let headers: HTTPHeaders =     [.authorization("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ   9.eyJYLUFwcC1SYXRlLUxpbWl0IjoiNTAwOjEwIiwiYWNjb3VudF9pZCI6IjE0MDkzMDI3MDAiLCJ   hdXRoX2lkIjoiMiIsImV4cCI6MTY3NDg5NjIxMCwiaWF0IjoxNjU5MzQ0MjEwLCJuYmYiOjE2NTkz   NDQyMTAsInNlcnZpY2VfaWQiOiI0MzAwMTE0ODEiLCJ0b2tlbl90eXBlIjoiQWNjZXNzVG9rZW4if   Q.nwgL3AMU216uu88opO2R4br3uMRE1_86V9w0Uh7TbN0")]
    
    
        AF.request(urlString, method: .get, headers: headers).responseJSON { response in
            print(response)
    
            switch response.result {
            case .success(let res):
    
                //print("tiers:", res)
                do {
                    let pokeJSON = try JSONSerialization.data(withJSONObject: res,   options: .prettyPrinted)
                    let pokelist = try JSONDecoder().decode(T.self, from: pokeJSON)
    
                    //print(pokelist)
    
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
