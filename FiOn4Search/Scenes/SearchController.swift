//
//  SearchController.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/03.
//

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

class SearchController: UIViewController, UIScrollViewDelegate {
    public static let shared = SearchController()
 
    //$0.text = "Data based on NEXON DEVELOPERS"
    private var bag = DisposeBag()
    private var myMatchModel = [MyMatch]()
    var tierData = [TierData]()
    
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
        $0.text = ""
        $0.textAlignment = .center
        $0.textColor = .lightGray
    }
    var levelLabel = UILabel().then {
        $0.text = ""
        $0.textAlignment = .center
        $0.textColor = .lightGray
    }
    let namestackView = UIStackView().then {
        $0.backgroundColor = .white
        $0.spacing = 10
        $0.alignment = .fill //y축
        $0.distribution = .fillEqually //x축
    }
    let emptyLabel = UILabel().then {
        $0.text = ""
        $0.textAlignment = .center
        $0.textColor = .red
    }
    let nexonLabel = UILabel().then {
        $0.text = "Data based on NEXON DEVELOPERS"
        $0.textAlignment = .center
        $0.textColor = .lightGray
    }
    
    //전적을 나타낼 테이블뷰
    var scoreTableView = UITableView().then {
        $0.register(MatchTableViewCell.self, forCellReuseIdentifier: "tableCell")
    }
    
//    var tierCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
//        $0.register(TierCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        $0.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
//        $0.backgroundColor = .red
//    }
    
    lazy var tierCollectionView : UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        //layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = CGSize(width: view.frame.width - 10.0, height: 140)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //cv.delegate = self
        //cv.dataSource = self
        cv.rx.setDelegate(self).disposed(by: bag)
        cv.register(TierCollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        return cv
    }()
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        
        searchTextField.rx.text.orEmpty
            .subscribe(onNext: { [weak self] count in
                guard let self = self else { return }
                self.userNameCount(count)
                print(count)
                self.userNickName = count
            }).disposed(by: bag)
        
        searchTextField.rx.text.orEmpty
            .bind(to: search.searchText)
            .disposed(by: bag)
        
        searchBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.myMatchModel.removeAll() //리로드전에 값 비우기.
                self.tierData.removeAll()
                self.scoreTableView.reloadData()//초기화하고 시작하자.
                //self.tierCollectionView.reloadData()
                self.getRequest()
                
                //self.search.obsearch() //textfield의 값을 제대로 전달하는지
//                self.search.accessidReq { str in
//                    print("전달하고 전달받은 값 :",str)
//                }
                
            }).disposed(by: bag)
        
        //버튼 탭했을때!
        searchBtn.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.search.accessidReq()
                self.bindCol()
            }
            .disposed(by: bag)
    }
    
    func bindCol() { 
        tierCollectionView.delegate = nil
        tierCollectionView.dataSource = nil
        
        self.search.tierDatas
            .bind(to: tierCollectionView.rx.items(cellIdentifier: "cell", cellType: TierCollectionViewCell.self)) { index, item, cell in
                
                cell.tierTimeLabel.text = item.tierTime
                cell.tierNameLabel.text = item.tierName
                
                let tierUrl = URL(string: item.tierUrl)
                cell.tierImgView.kf.indicatorType = .activity
                cell.tierImgView.kf.setImage(with: tierUrl, placeholder: nil, options: [.transition(.fade(1.0))], completionHandler: nil)
            }
            .disposed(by: bag)
        
    }
    
    //rx를 통해 데이터 넘겨주기.
    var search = Search()
//    lazy var search : Search = { Search() }()
    func fetch() {
        searchTextField.rx.text.orEmpty
            .bind(to: search.searchText)
            .disposed(by: bag)
    }
    
    
    //MARK: - configure
    func configure() {
        //요소가 보이는 부분은 view다.
        //addSubView는 매개변수로 추가할 뷰를 받는다.
        //class안에서 생성한 라이브러리기 때문에 self를 사용해주어야한다.
        view.addSubview(self.navigationBar)
//        view.addSubview(self.tierScrollView)
        view.addSubview(self.scoreTableView)
        scoreTableView.delegate = self
        scoreTableView.dataSource = self
        
        view.addSubview(self.searchstackView)
        searchstackView.addArrangedSubview(self.searchTextField)
        searchstackView.addArrangedSubview(self.searchBtn)
        
        view.addSubview(self.namestackView)
        namestackView.addArrangedSubview(self.nameLabel)
        namestackView.addArrangedSubview(self.levelLabel)
        view.addSubview(self.emptyLabel)
        
        //티어
        view.addSubview(self.tierCollectionView)
        //넥슨라벨
        view.addSubview(self.nexonLabel)
        
        //네비게이션바 타이틀 설정
        self.navigationItem.title = "유저 정보 검색"
        //테이블뷰의 도트 경계
        self.scoreTableView.frame = view.bounds
        self.tierCollectionView.frame = view.bounds
        
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
        self.emptyLabel.snp.makeConstraints {
            //nameLabel의 위치는 nameTextfield의 아래에 위치하기 때문에
            $0.top.equalTo(self.searchstackView.snp.bottom).offset(10)
            //좌우는 네임텍스트필드에 맞추기 위해
            //$0.leading.equalTo(self.nameTextfield)
            //$0.trailing.equalTo(self.nameTextfield)

            //만약 좌우를 같게 설정한다면 아래처럼 줄여서 쓸 수 있다.
            $0.leading.trailing.equalTo(self.searchstackView)
        }
        
        self.tierCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.namestackView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            //높이와 너비는 이런식으로!
            $0.height.equalTo(140)
        }
        
        self.scoreTableView.snp.makeConstraints {
            $0.top.equalTo(self.tierCollectionView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(self.tierCollectionView)
            //$0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(10)
            $0.bottom.equalTo(self.nexonLabel.snp.top)
        }
        
        self.scoreTableView.isHidden = true
        self.tierCollectionView.isHidden = true

        self.nexonLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.tierCollectionView)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
    }
    
    //MARK: - 입력제한
    func userNameCount(_ count: String) {
        //15자 이상 입력 방지.
        if count.count > 15 {
            let index = count.index(count.startIndex, offsetBy: 15)
            self.searchTextField.text = String(count[..<index])
        }
    }
    
    //MARK: - FETCH
    func getRequest() {
        ///엑세스 ID
        let accessid = API.getAccessId(name: self.userNickName)
        accessid.request(dataType: UserInfo.self) { [weak self] result in
            guard let self = self else { return }
//            print(result)
            switch result {
            case .success(let dict):
                self.scoreTableView.isHidden = false
                self.tierCollectionView.isHidden = false
                self.emptyLabel.text = ""
                self.nameLabel.text = "\(self.userNickName)"
                self.nameLabel.textColor = .black
                self.levelLabel.text = "감독레벨 : \(dict.level)"
                self.levelLabel.textColor = .black
                
        //MARK: - 매치 목록 id FETCH
        let matchId = API.getMatchId(accessId: dict.accessId, limit: 10)
        matchId.request(dataType: MatchList.self) { matchIdresult in
            //모델을 위한 임시 변수
            var vmatchResult = ""
            var vgoalTotal = 0
            var vnickName = ""
            var smatchResult = ""
            var sgoalTotal = 0
            var snickName = ""

            switch matchIdresult {
            case .success(let matchIdresult):
                for match in matchIdresult  {
                    //매치 정보 구하기.
                    let matchInfo = API.getMatchInfo(matchId: match)
                    matchInfo.request(dataType: Match.self) { matchresult in
                        switch matchresult {
                        case .success(let matchresult):
                            
                            let changeDate = changeDate(inputDate: matchresult.matchDate)
                            
                            //let matchDate = matchresult.matchDate // 매칭날짜
                            let matchInfoma = matchresult.matchInfo
                            //닉네임으로 sort해도..
                            //2. Match에서 matchInfo에서 nickname
                            //3. Match에서 matchInfo에서 matchDetail에서 matchResult
                            //4. Match에서 matchInfo에서 shoot에서 goalTotal //몇대몇
                            
                            for (index, info) in matchInfoma.enumerated() {
                                //print(index, info.nickname)
                                if index%2 == 0 {
                                    if info.shoot.goalTotal == 0 {
                                        if info.matchDetail.matchResult == "승" {
//                                            vmatchResult = "몰수승"
                                            vmatchResult = "승"
                                            vgoalTotal = 3
                                            //print("PK승")
                                        } else if info.matchDetail.matchResult == "패" {
                                            //print("PK패")
//                                            vmatchResult = "몰수패"
                                            vmatchResult = "패"
                                            vgoalTotal = 0
                                        }
                                    } else {
                                        vmatchResult = info.matchDetail.matchResult //승패
                                        vgoalTotal = info.shoot.goalTotal //골수
                                    }
                                    vnickName = info.nickname
                                    
                                } else {
                                    if info.shoot.goalTotal == 0 {
                                        if info.matchDetail.matchResult == "승" {
//                                            smatchResult = "몰수승"
                                            smatchResult = "승"
                                            sgoalTotal = 3
                                            //print("PK승")
                                        } else if info.matchDetail.matchResult == "패" {
                                            //print("PK패")
//                                            smatchResult = "몰수패"
                                            smatchResult = "패"
                                            sgoalTotal = 0
                                        }
                                    } else {
                                        smatchResult = info.matchDetail.matchResult //승패
                                        sgoalTotal = info.shoot.goalTotal //골수
                                    }
                                    snickName = info.nickname
                                }
                            }
                            self.myMatchModel.append(MyMatch(matchDate: changeDate, myMatchDetail: MyMatchDetail(nickname: vnickName, matchResult: vmatchResult, goalTotal: vgoalTotal, vsnickname: snickName, vsmatchResult: smatchResult, vsgoalTotal: sgoalTotal)))
                            
                            self.myMatchModel.sort(by: {$0.matchDate > $1.matchDate})
                            self.scoreTableView.reloadData()
                            
                        case .failure(let error):
                            print("2",error)
                        }
                    }
                }
            case .failure(let error):
                print("matchId error : ",error)
            }
                }
            case .failure(let error):
                print("3",error)
                self.nameLabel.text = ""
                self.levelLabel.text = ""
                self.emptyLabel.text = "존재하지 않는 구단주명입니다."
                self.nameLabel.textColor = .red
                self.tierCollectionView.isHidden = true
                self.scoreTableView.isHidden = true
            }
        }
    }
}


//MARK: - Tableview Extension
extension SearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myMatchModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! MatchTableViewCell
        
        cell.matchDateLabel.text = myMatchModel[indexPath.row].matchDate
        
        cell.homeResultLabel.text = myMatchModel[indexPath.row].myMatchDetail.matchResult
        cell.homeNameLabel.text = myMatchModel[indexPath.row].myMatchDetail.nickname
        cell.homeGoalLabel.text = String(myMatchModel[indexPath.row].myMatchDetail.goalTotal)
        
        cell.awayResultLabel.text = myMatchModel[indexPath.row].myMatchDetail.vsmatchResult
        cell.awayNameLabel.text = myMatchModel[indexPath.row].myMatchDetail.vsnickname
        cell.awayGoalLabel.text = String(myMatchModel[indexPath.row].myMatchDetail.vsgoalTotal)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.text = "최근 경기 결과"
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .label
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.scoreTableView.frame.width, height: 25))
        headerView.addSubview(label)
        headerView.backgroundColor = .lightGray
        label.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
        
        return headerView
         
    }
    
    //키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}
