//
//  mytrashCode.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/22.
//

import Foundation

/*
 /*
     //된다 이렇게하면?
     //addSubview = 수직 추가?
     //addArrangedSubview = 수평 추가?
     //그러나 이미 초기화를 했다면 subView는 사용되지 않는다.
     //그리고 추가할때 subview들의 베이스는 수평이다.
     //나중에 각 라벨에 어떻게 값을 넣을것인가가 관건.
     //값을 넣는 방법을 아직 찾지 못함.
     let tierHorizontalStackView = UIStackView().then {
         //$0.axis = .horizontal //이걸 하지 않아도 일단 수평으로 추가된다.
         $0.spacing = 5
         $0.distribution = .fillEqually //반반
         
         let tierLabel = UILabel()
         tierLabel.text = "안녕"
         tierLabel.textAlignment = .center
         let tierTimeLabel = UILabel()
         tierTimeLabel.text = "하이"
         tierTimeLabel.textAlignment = .center
         
         let verticalstack = UIStackView()
         verticalstack.axis = .vertical
         verticalstack.addArrangedSubview(tierLabel)
         verticalstack.addArrangedSubview(tierTimeLabel)
         
         //let tierUIView = UIView()
         let tierImage = UIImageView()
         tierImage.backgroundColor = .red

         $0.addArrangedSubview(tierImage)
         $0.addArrangedSubview(verticalstack)
     }
  
  
  ////
  //이걸로 불러오려했으나.. 흠...
  self.imsigetRequest { result in
      print(result)
      self.enterAccessId()
  }
  var getAccessId = ""
  
  func imsigetRequest(tierInfo: @escaping (Result<Any?,CustomError>)->()) {
      //엑세스아이디찾기
      let accessid = API.getAccessId(name: self.userNickName)
      accessid.arrrequest(dataType: UserInfo.self) { result in
          print(result)
          switch result {
          case .success(let dict):
              print(dict)
              let sendAccessId = dict.accessId
              tierInfo(.success(sendAccessId))
              self.getAccessId = dict.accessId
              print("id : ", self.getAccessId)
              
          case .failure(let error):
              print(error)
              tierInfo(.failure(.invalidData))
          }
      }
  }
  
  func enterAccessId() {
      
      let tier = API.getTier(accessId: self.getAccessId)
      
      print("enter",self.getAccessId)
  }
  
  
 */
 
 
 
 
 
 
 
 */
