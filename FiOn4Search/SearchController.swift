//
//  SearchController.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/03.
//
//사용자들이 원하는 스쿼드 메이커??

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import SwiftyJSON
import Alamofire
import CloudKit

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

    //$0.text = "Data based on NEXON DEVELOPERS"
    private var viewModel = ProductViewModel()
    private var bag = DisposeBag()
    var userNickName = ""
    //스토리보드로 라이브러리를 추가하는게 아니라 코드로 라이브러리를 추가해줘야하기 때문에.
    //let 이름 = 라이브러리이름 후에 () 로 개체로 만든다.
    
    //네비게이션아이템은 네비게이션바안에 있기 떄문에 이곳에서 직접 설정은 불가능 하다.
    let navigationBar = UINavigationBar()

    //1:1공식경기와 2:2공식경기의 티어를 나타낼 페이지컨트롤
    let tierPageControl = UIPageControl().then {
        $0.numberOfPages = 2
    }
    
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
    
    let searchstackView = UIStackView().then {
        $0.backgroundColor = .white
        //$0.alignment = .center
        $0.spacing = 10
    }
    
    
    //전적을 나타낼 테이블뷰
    let scoreTableView = UITableView().then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    let nameLabel = UILabel().then {
        $0.text = "유저닉네임"
        $0.textAlignment = .center
        $0.textColor = .lightGray
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        bindTableViewData()

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
                self.MaingetUserId()
            }).disposed(by: bag)
        
//        nameLabel.rx.observe(String.self, "text")
//            .subscribe(onNext: { text in
//                print("nameLabel 변경됨")
//                self.nameLabel.textColor = .black
//            }).disposed(by: bag)
        
    }
        
        
    //MARK: - configure
    func configure() {
        //요소가 보이는 부분은 view다.
        //addSubView는 매개변수로 추가할 뷰를 받는다.
        //class안에서 생성한 라이브러리기 때문에 self를 사용해주어야한다.
        view.addSubview(self.navigationBar)
        view.addSubview(self.tierPageControl)
        view.addSubview(self.scoreTableView)
        view.addSubview(self.nameLabel)
        
        view.addSubview(self.searchstackView)
        searchstackView.addArrangedSubview(self.searchTextField)
        searchstackView.addArrangedSubview(self.searchBtn)
        
        
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
        self.nameLabel.snp.makeConstraints {
            //nameLabel의 위치는 nameTextfield의 아래에 위치하기 때문에
            $0.top.equalTo(self.searchstackView.snp.bottom).offset(24)
            //좌우는 네임텍스트필드에 맞추기 위해
            //$0.leading.equalTo(self.nameTextfield)
            //$0.trailing.equalTo(self.nameTextfield)

            //만약 좌우를 같게 설정한다면 아래처럼 줄여서 쓸 수 있다.
            $0.leading.trailing.equalTo(self.searchstackView)
        }
        
        self.tierPageControl.snp.makeConstraints {
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().offset(10)
            //높이와 너비는 이런식으로!
            $0.height.equalTo(150)
            
        }
        
        self.scoreTableView.snp.makeConstraints {
            $0.top.equalTo(self.tierPageControl.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(self.tierPageControl)
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
    

    
    func userNameCount(_ count: String) {
        //15자 이상 입력 방지.
        if count.count > 15 {
            let index = count.index(count.startIndex, offsetBy: 15)
            self.searchTextField.text = String(count[..<index])
        }
    }
    
    func MaingetUserId() {
        var accessId = ""
        
        let baseUrl = "https://api.nexon.co.kr/fifaonline4/v1.0/users"
        let accessUrl = baseUrl + "?nickname=" + userNickName
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
                        self.nameLabel.text = "\(self.userNickName)  \(urlList.level)"
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
                    
                    print(tierList)
                    
                    for i in tierList {
                        print(i.division)
                        
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
}


/*
 서치 화면
 1. 선수 아이디로 검색
 2. 처음 줄 닉네임, 레벨? 정도.
 3. 현재 티어와, 최고 티어.
 4. 최근 전적.
 */


