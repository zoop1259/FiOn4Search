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
 
 //MARK: - Fetch
 func MaingetUserId() {
     var accessId = ""
     
     let baseUrl = "https://api.nexon.co.kr/fifaonline4/v1.0/users?"
//        let nameUrl = baseUrl + "?nickname=" + userNickName
//        let accessUrl = baseUrl + "/\(urlList.accessId)/maxdivision"
     let matchUrl = baseUrl + "/\(accessId)/matches?matchtype=50&offset=0&limit=10"
    // let matchInfoUrl = "https://api.nexon.co.kr/fifaonline4/v1.0/matches/" + matchId

     let urlString = "https://api.nexon.co.kr/fifaonline4/v1.0/users?nickname="

     print("닉네임 : ", userNickName)
     let url = urlString + userNickName
     
     //그런데 이렇게 해도 된다. 이게 더 이쁜듯...
     let headers: HTTPHeaders = [.authorization("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJYLUFwcC1SYXRlLUxpbWl0IjoiNTAwOjEwIiwiYWNjb3VudF9pZCI6IjE0MDkzMDI3MDAiLCJhdXRoX2lkIjoiMiIsImV4cCI6MTY3NDg5NjIxMCwiaWF0IjoxNjU5MzQ0MjEwLCJuYmYiOjE2NTkzNDQyMTAsInNlcnZpY2VfaWQiOiI0MzAwMTE0ODEiLCJ0b2tlbl90eXBlIjoiQWNjZXNzVG9rZW4ifQ.nwgL3AMU216uu88opO2R4br3uMRE1_86V9w0Uh7TbN0")]
  
     //AccessId 찾기.
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
                     self.nameLabel.text = "구단주 닉네임 : \(self.userNickName)  구단주 레벨 : \(urlList.level)"
                     self.nameLabel.textColor = .black
                     
     //티어 찾기.
     let tierUrl = baseUrl + "/\(urlList.accessId)/maxdivision"
     AF.request(tierUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" , method: .get, headers: headers)
         .responseJSON { tier in
         print("tierUrl", tierUrl)
         switch tier.result {
         case .success(let tiers):
             
             print("tiers:", tiers)
             do {
                 let tierJSON = try JSONSerialization.data(withJSONObject: tiers, options: .prettyPrinted)
                 let tierList = try JSONDecoder().decode([TierInfo].self, from: tierJSON)
                 
//                    print(tierList)
                                     
                 for i in tierList {
                     print(i.division)
                     
                     //var a = self.tierFind(tier: i.division)
                     //print(a)
                     
//                        아프리카TV규직
                     
//                        if i.matchType == 50 {
//                            let a = i.division
//                            self.tierFind(tier: a)
//                            let b = self.tierFind(tier: a)
//                            print("1:1 : ", b)
//                        } else {
//                            let c = i.division
//                            self.tierFind2(tier: c)
////                            let d = self.tierFind2(tier: c)
////                            print("2:2 :", d)
//                        }
                }
                 
     //여기서 매칭 정보 구하기.
             } catch {
                 //나중에 페이저뷰를 가리고 라벨 띄우게.
                 print(error)
             }
         case .failure(let error):
             print(error)
         }
     }
                     
                 } catch {
                     self.nameLabel.textColor = .red
                     self.nameLabel.text = "아이디가 없습니다."
                 }
                 
             case .failure(let error):
                 print(error)
             }
             //여기까진 데이터가 남는군.
             print("과연 밖에서도 데이터가 연결될까? :", accessId)
         }
     //여기선 데이터 증발
 }
 
 
//    func getRequest() {
//        let api = API.getAccessId(name: self.userNickName)
//        api.request { result in
//            print(result)
//            switch result {
//            case .success(let dict):
//                print(dict as Any)
//            case .failure(let e):
//                print(e)
//            }
//        }
//    }

 //match데이터 모델 만들기 전
 
 //음... 바보같다. 이렇게하면 당연히 의미가 없지.
//                                for i in 1...index+1 {
//                                    //print(index, info.nickname)
//
//                                    if i%2 == 1 {
//                                        print(i)
//                                        a.append(info.nickname)
//                                    } else if i%2 == 0 {
//                                        print(i)
//                                        b.append(info.nickname)
//                                    }
//                                }
 for infoma in matchInfoma {
     
//                                for i in 0..<matchInfoma.count {
//                                    if i%2 == 0 {
//                                        print()
//                                    }
//                                }
     
     let nickName = infoma.nickname // 닉네임
     
 //3. Match에서 matchInfo에서 matchDetail에서 matchResult
     let matchDetail = infoma.matchDetail
     let matchResult = matchDetail.matchResult //승패
     //c.append(matchDetail.matchResult)
 //4. Match에서 matchInfo에서 shoot에서 goalTotal //몇대몇
     let shoots = infoma.shoot
     let goal = shoots.goalTotal //골.
     //d.append(shoots.goalTotal)
     
     
//                                self.myMatchModel.append(MyMatch(matchDate: matchDate, nickname: nickName, matchResult: matchResult, goalTotal: goal))
     //self.myMatchModel.append(MyMatch(matchDate: matchDate, myMatchDetail: MyMatchDetail(nickname: nickName, matchResult: matchResult, goalTotal: goal)))

     
//                                self.myMatchModel.append(MyMatch(matchDate: matchresult.matchDate, myMatchDetail: [MyMatchDetail.init(nickname: infoma.nickname, matchResult: matchDetail.matchResult, goalTotal: shoots.goalTotal)]))
//                                self.myMatchModel.sort(by: {$0.matchDate > $1.matchDate })
 
 
 
 */

/*
 rx용 tableview 프렉티스였는데
 
 //임시모델
 struct Product {
     let imageName: String
     let title: String
     let hi: String
 }
 struct ProductViewModel {
     //인스턴스를 생성하기 위해 괄호를 추가.
     var items = PublishSubject<[Product]>()
     
     func fetchItems() {
         let products = [
             Product(imageName: "house", title: "Home", hi: "hihi"),
             Product(imageName: "gear", title: "Settings", hi: "hihi"),
             Product(imageName: "person.circle", title: "Profile", hi: "hihi" ),
             Product(imageName: "airplane", title: "Flights", hi: "hihi"),
             Product(imageName: "bell", title: "Activity", hi: "hihi")
         ]
         items.onNext(products)
         items.onCompleted()
     }
 }
 
 //MARK: - 임시 Fetch
//    func bindTableViewData() {
//        //세가지를 먼저 하고 싶다.
//        //1. bind items to table
//        viewModel.items.bind(
//            to: scoreTableView.rx.items(cellIdentifier: "cell",
//                                   cellType: UITableViewCell.self)
//        ) { row, model, cell in
//
//            //cell.textLabel?.text = self.myMatchModel[row].matchDate ?? model.title
//            cell.textLabel?.text = model.title
//            cell.imageView?.image = UIImage(systemName: model.imageName)
//        }.disposed(by: bag)
//        //2. bind a model selected handler
//        scoreTableView.rx.modelSelected(Product.self).bind { product in
//            print(product.title)
//        }.disposed(by: bag)
//
//        //3. fetch items
//        viewModel.fetchItems()
//    }
 
//    func bindTableViewData() {
//        let cellType = Observable.of(viewModel.self)
//            cellType
//                .bind(to: scoreTableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (row, element, cell) in
//                cell.backgroundColor = UIColor.clear
//                cell.titleLabel.text = element["Name"]
//                cell.licenseLabel.text = element["License"]
//                cell.urlLabel.text = element["URL"]
//            }.disposed(by: bag)
//    }
 
 
 */
