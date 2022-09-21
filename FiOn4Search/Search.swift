//
//  Search.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/09/21.
//

import Foundation
import RxSwift
import RxCocoa

class Search {
    
    let searchText = BehaviorRelay<String>(value: "")
    var searchController = SearchController()
    
    //Driver는 에러를 감지하지 않음. 그냥 에러없는 옵저버블이라고 생각하자.
//    let combinedText : Driver<String>
    
    func obsearch() {
        //searchText = BehaviorRelay<String>
        print("이건 searchText", searchText)
        
        //value를 통해 가져와야 String
        let a = searchText.value
    }
    
    
    
    
}
