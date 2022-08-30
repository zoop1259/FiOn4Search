//
//  SearchController.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/03.
//
//사용자들이 원하는 스쿼드 메이커??

/*
 서치 화면
 1. 선수 아이디로 검색
 2. 처음 줄 닉네임, 레벨? 정도.
 3. 현재 티어와, 최고 티어. //이걸 페이지컨트롤로 할지, 아니면 컬렉션뷰로 할지.
 4. 컬렉션뷰는 첫 프로젝트에서 사용해봤으니 페이징킷을 사용하여 한번 표현해보고 싶을뿐이다.
 5. 최근 전적.
 6. APIKey값 가리는 방법.
 */

/*
 리팩토링시에 해야할것 (후에 적용할것, 생각나는대로 적는중). 라고하기엔 당장 시작하는것이 좋겠다.
 1. escaping 확실히 배우기 notification을 사용하지 않기 위함. (노티도 결국 escaping을 사용)
 2. escaping을 통해 textfield의 값을 전달하여 검색하는 api를 우선 생성
 3. 기본적인 api구성후 중복을 방지하고 클린코드를 위해 복잡한escaping을 통해 API Manager 생성하기
 4.
 */


import UIKit

import SnapKit 
import Then
import RxSwift
import RxCocoa
import SwiftyJSON
import Alamofire
import CloudKit
import Kingfisher
import os

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

class SearchController: UIViewController {
    public static let shared = SearchController()
 
    //$0.text = "Data based on NEXON DEVELOPERS"
    private var viewModel = ProductViewModel()
    private var bag = DisposeBag()
    private var myMatchModel = [MyMatch]()
    var userNickName = ""
    //스토리보드로 라이브러리를 추가하는게 아니라 코드로 라이브러리를 추가해줘야하기 때문에.
    //let 이름 = 라이브러리이름 후에 () 로 개체로 만든다.
    
    //네비게이션아이템은 네비게이션바안에 있기 떄문에 이곳에서 직접 설정은 불가능 하다.
    let navigationBar = UINavigationBar()
    
    //MARK: - Search init
    let searchTextField = UITextField().then {
        $0.placeholder = "유저검색"
        $0.textColor = .black
        $0.borderStyle = .bezel
    }
    // 검색 버튼
    lazy var searchBtn = UIButton().then {
        $0.tintColor = .black
        $0.backgroundColor = .white
        $0.setTitle("검색", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.black.cgColor
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        //$0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    //검색 스택뷰
    let searchstackView = UIStackView().then {
        $0.backgroundColor = .white
        //$0.alignment = .center
        $0.spacing = 10
    }
    
    //MARK: - User Basic Info init
    let nameLabel = UILabel().then {
        $0.text = "감독이름"
        $0.textAlignment = .center
        $0.textColor = .lightGray
    }
    let levelLabel = UILabel().then {
        $0.text = "감독레벨"
        $0.textAlignment = .center
        $0.textColor = .lightGray
    }
    let namestackView = UIStackView().then {
        $0.backgroundColor = .white
        $0.spacing = 10
        $0.alignment = .fill //y축
        $0.distribution = .fillEqually //x축
    }
    
    
    
    //MARK: - Tier init
    //1:1공식경기와 2:2공식경기의 티어를 나타낼 스크롤뷰
    let tierScrollView = UIScrollView().then {//_ in
        $0.backgroundColor = .green
    }
    
    let tierPageControl = UIPageControl().then {
        //페이지 컨트롤로 1vs1,2vs2를 나타내야함
        $0.numberOfPages = 2
        $0.backgroundColor = .black
    }

    
    let tierVerticalStackView = UIStackView().then {
        $0.axis = .vertical
    }

    let tierDivLabel = UILabel().then {  //무슨티어인지
        $0.text = "1번"
        $0.textAlignment = .center
        $0.textColor = .lightGray
    }

    let tierTimeLabel = UILabel().then { //최초티어달성시간
        $0.text = "2번"
        $0.textAlignment = .center
        $0.textColor = .lightGray
    }
    
    let tierImg = UIImageView().then {//_ in
//        $0.withTintColor(.red)
        
        $0.backgroundColor = .white
    }
    //2:2
//    let tierVerticalStackView22 = UIStackView().then {
//        $0.axis = .vertical
//    }
//
//    let tierDivLabel22 = UILabel().then {  //무슨티어인지
//        $0.text = "1번"
//        $0.textAlignment = .center
//        $0.textColor = .lightGray
//    }
//
//    let tierTimeLabel22 = UILabel().then { //최초티어달성시간
//        $0.text = "2번"
//        $0.textAlignment = .center
//        $0.textColor = .lightGray
//    }
//
//    let tierImg22 = UIImageView().then {//_ in
////        $0.withTintColor(.red)
//        $0.backgroundColor = .red
//    }
    let tierStackView11 = UIStackView().then {
        $0.spacing = 10
        //$0.distribution = .fillEqually
        $0.alignment = .center
    }
//    let tierStackView22 = UIStackView().then {
//        $0.spacing = 10
//    }
    
    //모든걸 모은 스택뷰
    let tierStackView = UIStackView().then {//_ in
        //$0.spacing = 10
        $0.axis = .horizontal
    }
    

    //전적을 나타낼 테이블뷰
    let scoreTableView = UITableView().then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    let baseUrl = "https://api.nexon.co.kr/fifaonline4/v1.0/users?"
//        let urlString = "https://api.nexon.co.kr/fifaonline4/v1.0/users?nickname="
    let nickString = "nickName="
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        bindTableViewData()
        //tierFind()

        searchTextField.rx.text.orEmpty
            .subscribe(onNext: { count in
                //입력이 될때마다 culc호출
                self.userNameCount(count)
                print(count)
                self.userNickName = count
                
            }).disposed(by: bag)
        
        searchBtn.rx.tap
            .subscribe(onNext: {_ in
                //getUserId()
                //self.MaingetUserId()
                self.getRequest()
                
            }).disposed(by: bag)
        
        
        
//        nameLabel.rx.observe(String.self, "text")
//            .subscribe(onNext: { text in
//                print("nameLabel 변경됨")
//                self.nameLabel.textColor = .black
//            }).disposed(by: bag)
        
        /*
         ApiManager.shared.AFPokemos { (response) in
             
             if let pokemons = response.results, pokemons.count > 0 {
                 print("af이름 : \(pokemons[0].name ?? "")")
             }
         } fail: {
             print("패치 실패")
         }
         
         func AFPokemos(success: @escaping ((UserInfo) -> Void),
                         fail: @escaping (() -> Void)) {
             
             ServiceManager.shared.AFService(urlString: "https://pokeapi.co/api/v2/pokemon/") { (response: UserInfo) in success(response)
             } fail : {
                 fail()
             }
         }
         */
        
    }
        
    
        
    //MARK: - configure
    func configure() {
        //요소가 보이는 부분은 view다.
        //addSubView는 매개변수로 추가할 뷰를 받는다.
        //class안에서 생성한 라이브러리기 때문에 self를 사용해주어야한다.
        view.addSubview(self.navigationBar)
        view.addSubview(self.tierScrollView)
        view.addSubview(self.scoreTableView)
        
        
        view.addSubview(self.searchstackView)
        searchstackView.addArrangedSubview(self.searchTextField)
        searchstackView.addArrangedSubview(self.searchBtn)
        
        view.addSubview(self.namestackView)
        namestackView.addArrangedSubview(self.nameLabel)
        namestackView.addArrangedSubview(self.levelLabel)
        
        //스크롤뷰에 추가
        tierScrollView.delegate = self
        tierScrollView.isScrollEnabled = true
        tierScrollView.isPagingEnabled = true
        tierScrollView.addSubview(self.tierPageControl)
        tierScrollView.addSubview(tierStackView)
        //티어이름과 티어달성시간 버티컬로 추가
        tierVerticalStackView.addArrangedSubview(self.tierDivLabel)
        tierVerticalStackView.addArrangedSubview(self.tierTimeLabel)
//        tierVerticalStackView22.addArrangedSubview(self.tierDivLabel22)
//        tierVerticalStackView22.addArrangedSubview(self.tierTimeLabel22)
        //티어 이미지와 버티컬로 추가한 라벨들 추가
        tierStackView11.addArrangedSubview(self.tierImg)
        tierStackView11.addArrangedSubview(self.tierVerticalStackView)
//        tierStackView22.addArrangedSubview(self.tierImg22)
//        tierStackView22.addArrangedSubview(self.tierVerticalStackView22)
        
        tierStackView.addArrangedSubview(self.tierStackView11)
//        tierStackView.addArrangedSubview(self.tierStackView22)

        
        
        //네비게이션바 타이틀 설정
        self.navigationItem.title = "유저 정보 검색"
        //테이블뷰의 도트 경계
        self.scoreTableView.frame = view.bounds
        
        //각 라이브러리의 위치를 정해주자.
        //UITextfield
        self.searchstackView.snp.makeConstraints {
            //view의 탑에 위치시키기 위해 top 사용
            //위에서 좀 아래에 위치하기 위해 offset사용
            //네비게이션바 바로 밑에 설정.
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            //leading은 시작하는 방향 24만큼 띄워져서 시작?
            $0.leading.equalToSuperview().offset(24)
            //trailing은 끝나는 방향 -24만큼 띄워져서 끝남?
            $0.trailing.equalToSuperview().offset(-24)
            self.searchBtn.snp.makeConstraints {
                $0.width.equalTo(50)
            }
        }

        //UILabel
        self.namestackView.snp.makeConstraints {
            //nameLabel의 위치는 nameTextfield의 아래에 위치하기 때문에
            $0.top.equalTo(self.searchstackView.snp.bottom).offset(10)
            //좌우는 네임텍스트필드에 맞추기 위해
            //$0.leading.equalTo(self.nameTextfield)
            //$0.trailing.equalTo(self.nameTextfield)

            //만약 좌우를 같게 설정한다면 아래처럼 줄여서 쓸 수 있다.
            $0.leading.trailing.equalTo(self.searchstackView)
        }
        
        self.tierScrollView.snp.makeConstraints {
            $0.top.equalTo(self.namestackView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
//            $0.centerX.equalToSuperview()
//            $0.centerY.equalToSuperview()
            //높이와 너비는 이런식으로!
            $0.height.equalTo(150)
        }
        self.tierPageControl.snp.makeConstraints {
            $0.top.equalTo(self.tierScrollView.snp.top).offset(125)
            $0.centerX.equalToSuperview()
        }
        
        self.tierStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        
//            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        self.scoreTableView.snp.makeConstraints {
            $0.top.equalTo(self.tierScrollView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(self.tierScrollView)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(10)
        }

    }
    
    func bindTableViewData() {
        //세가지를 먼저 하고 싶다.
        //1. bind items to table
        viewModel.items.bind(
            to: scoreTableView.rx.items(cellIdentifier: "cell",
                                   cellType: UITableViewCell.self)
        ) { row, model, cell in
            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageName)
        }.disposed(by: bag)
        //2. bind a model selected handler
        scoreTableView.rx.modelSelected(Product.self).bind { product in
            print(product.title)
        }.disposed(by: bag)

        //3. fetch items
        viewModel.fetchItems()
    }
    
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
    

    
    
    //MARK: - 입력제한
    func userNameCount(_ count: String) {
        //15자 이상 입력 방지.
        if count.count > 15 {
            let index = count.index(count.startIndex, offsetBy: 15)
            self.searchTextField.text = String(count[..<index])
        }
    }
    
    
    
//    아프리카tv규직
    func getRequest() {
        //엑세스아이디찾기
        let accessid = API.getAccessId(name: self.userNickName)
        accessid.arrrequest(dataType: UserInfo.self) { result in
            print(result)
            switch result {
            case .success(let dict):
                print(dict)
                self.nameLabel.text = "\(self.userNickName)"
                self.nameLabel.textColor = .black
                self.levelLabel.text = "감독레벨 : \(dict.level)"
                self.levelLabel.textColor = .black
            //티어찾기.
            let tier = API.getTier(accessId: dict.accessId)
            tier.arrrequest(dataType: [TierInfo].self) { tierresult in
            switch tierresult {
            case .success(let tier):
                print(tier)
                var tierNameArr = [String]()
                var tierTimeArr = [String]()
                var tierImgUrlArr = [String]()
                
                for list in tier {
                    
                    let oneone = 50
                    let twotwo = 52
                    //스크롤뷰에 값을 각각 집어넣는방법
                    
                    if list.matchType == 50 {
                        print(findTier(rankType: oneone ?? 50, tier: list.division ?? 0, achievementDate: list.achievementDate ?? ""))
                        let oneoneData = findTier(rankType: oneone ?? 50, tier: list.division ?? 0, achievementDate: list.achievementDate ?? "")

                        tierNameArr.append(oneoneData.tierName)
                        tierTimeArr.append(oneoneData.achievementDate)
                        tierImgUrlArr.append(oneoneData.tierImgUrl)

                        let asd = oneoneData.tierImgUrl
                        print("url",asd)
                        let asdasd = oneoneData.tierName
                        print("tier이름",asdasd)
                        self.tierTimeLabel.text = oneoneData.achievementDate
                        self.tierDivLabel.text = oneoneData.tierName
                        
                        let oneoneUrl = URL(string:oneoneData.tierImgUrl)
                        self.tierImg.backgroundColor = .white
                        self.tierImg.kf.indicatorType = .activity
                        self.tierImg.kf.setImage(with: oneoneUrl, placeholder: nil, options: [.transition(.fade(1.0))], progressBlock: nil)

                    } else if list.matchType == 52 {
                        print(findTier22(rankType: twotwo ?? 52, tier: list.division ?? 0, achievementDate22: list.achievementDate ?? ""))
                        let twotwoData = findTier22(rankType: twotwo ?? 50, tier: list.division ?? 0, achievementDate22: list.achievementDate ?? "")

                        tierNameArr.append(twotwoData.tierName22)
                        tierTimeArr.append(twotwoData.achievementDate22)
                        tierImgUrlArr.append(twotwoData.tierImgUrl22)

                        let asd = twotwoData.tierImgUrl22
                        print("url",asd)
                        let asdasd = twotwoData.tierName22
                        print("tier이름",asdasd)

                        let twotwoUrl = URL(string:twotwoData.tierImgUrl22)
//                                self.tierImg22.backgroundColor = .white
//                                self.tierImg22.kf.indicatorType = .activity
//                                self.tierImg22.kf.setImage(with: twotwoUrl, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                    }
                    
//                            if self.tierPageControl.currentPage == 0 {
//
//                                print("현재페이지 :",self.tierPageControl.currentPage)
//                                if list.matchType == 50 {
//                                    print(findTier(rankType: oneone ?? 50, tier: list.division ?? 0, achievementDate: list.achievementDate ?? ""))
//                                    let oneoneData = findTier(rankType: oneone ?? 50, tier: list.division ?? 0, achievementDate: list.achievementDate ?? "")
//                                    self.tierTimeLabel.text = oneoneData.achievementDate
//                                    self.tierDivLabel.text = oneoneData.tierName
//
//
//                                    let asd = oneoneData.tierImgUrl
//                                    print("url",asd)
//                                    let asdasd = oneoneData.tierName
//                                    print("tier이름",asdasd)
//
//                                    let oneoneUrl = URL(string:oneoneData.tierImgUrl)
//                                    self.tierImg.backgroundColor = .white
//                                    self.tierImg.kf.indicatorType = .activity
//                                    self.tierImg.kf.setImage(with: oneoneUrl, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
//
//                                }
//                            } else if self.tierPageControl.currentPage == 1 {
//                                if list.matchType == 52 {
//                                    print(findTier22(rankType: twotwo ?? 52, tier: list.division ?? 0, achievementDate22: list.achievementDate ?? ""))
//                                    let twotwoData = findTier22(rankType: twotwo ?? 50, tier: list.division ?? 0, achievementDate22: list.achievementDate ?? "")
//                                    self.tierTimeLabel22.text = twotwoData.achievementDate22
//                                    self.tierDivLabel22.text = twotwoData.tierName22
//
//
//                                    let asd = twotwoData.tierImgUrl22
//                                    print("url",asd)
//                                    let asdasd = twotwoData.tierName22
//                                    print("tier이름",asdasd)
//
//                                    let twotwoUrl = URL(string:twotwoData.tierImgUrl22)
//                                    self.tierImg22.backgroundColor = .white
//                                    self.tierImg22.kf.indicatorType = .activity
//                                    self.tierImg22.kf.setImage(with: twotwoUrl, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
//
//                                }
//                            }
                }
                
            case .failure(let error):
                print(error)
            }
                }
        //매치 목록 id 구하기.
        let matchId = API.getMatchId(accessId: dict.accessId, limit: 3)
        matchId.arrrequest(dataType: MatchList.self) { matchIdresult in
            switch matchIdresult {
            case .success(let matchIdresult):
                //print("matchId fin:",matchIdresult)
                print("만들어야될 카운트",matchIdresult.count)
                for match in matchIdresult  {
                    
                    //매치 정보 구하기.
                    let matchInfo = API.getMatchInfo(matchId: match)
                    matchInfo.arrrequest(dataType: Match.self) { matchresult in
                        switch matchresult {
                        case .success(let matchresult):
                            //print(matchresult)
                            //print("성공")
                            //0. Match //공통
                            //1. Match에서 matchDate
                            let matchDate = matchresult.matchDate // 매칭날짜
                            //2. Match에서 matchInfo에서 nickname
                            let matchInfoma = matchresult.matchInfo
                            
                            for infoma in matchInfoma {
                                
                                let nickName = infoma.nickname // 닉네임
                                
                            //3. Match에서 matchInfo에서 matchDetail에서 matchResult
                                let matchDetail = infoma.matchDetail
                                let matchResult = matchDetail.matchResult //승패
                            //4. Match에서 matchInfo에서 shoot에서 goalTotal //몇대몇
                                let shoots = infoma.shoot
                                let goal = shoots.goalTotal //골.
//                                self.myMatchModel.append(MyMatch(matchDate: matchDate, nickname: nickName, matchResult: matchResult, goalTotal: goal))
                                //self.myMatchModel.append(MyMatch(matchDate: matchDate, myMatchDetail: MyMatchDetail(nickname: nickName, matchResult: matchResult, goalTotal: goal)))
                                
                                
                                
//                                self.myMatchModel.append(MyMatch(matchDate: matchresult.matchDate, myMatchDetail: [MyMatchDetail.init(nickname: infoma.nickname, matchResult: matchDetail.matchResult, goalTotal: shoots.goalTotal)]))
//                                self.myMatchModel.sort(by: {$0.matchDate > $1.matchDate })
                                
                                
                                
                                //print(self.myMatchModel)
                            }
                        case .failure(let error):
                            print(error)
                        }
                        print("모델: ",self.myMatchModel)

//                        print("내가만든 모델의 카운트",self.myMatchModel.count)
                    }

                    
                }
            case .failure(let error):
                print("matchId error : ",error)
            }
                }
            case .failure(let error):
                print(error)
                self.nameLabel.text = "구단주명이 존재하지 않습니다."
                self.nameLabel.textColor = .red
            }
        }
    }
    
    func selectedPage(currentPage: Int) {
        tierPageControl.currentPage = currentPage
    }
    
}


extension SearchController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.width
        tierPageControl.currentPage = Int(pageNumber)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let size = tierScrollView.contentOffset.x / tierScrollView.frame.size.width
        selectedPage(currentPage: Int(round(size)))
        os_log("x스크롤 시작점 -> \(self.tierScrollView.bounds.origin.x)\n 사진의 y스크롤 시작점 -> \(self.tierScrollView.bounds.origin.y)")
    }
}
