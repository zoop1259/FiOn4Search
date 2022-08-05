//
//  SearchController.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/03.
//

import UIKit

import SnapKit
import Then

class SearchController: UIViewController {

    //$0.text = "Data based on NEXON DEVELOPERS"
    
    //스토리보드로 라이브러리를 추가하는게 아니라 코드로 라이브러리를 추가해줘야하기 때문에.
    //let 이름 = 라이브러리이름 후에 () 로 개체로 만든다.
    
    //네비게이션아이템은 네비게이션바안에 있기 떄문에 이곳에서 직접 설정은 불가능 하다.
    let navigationBar = UINavigationBar()
    
    let searchBar = UISearchBar()
    
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
        
    }
    
    
    //MARK: - configure
    func configure() {
        //요소가 보이는 부분은 view다.
        //addSubView는 매개변수로 추가할 뷰를 받는다.
        //class안에서 생성한 라이브러리기 때문에 self를 사용해주어야한다.
        view.addSubview(self.navigationBar)
        view.addSubview(self.searchBar)
        view.addSubview(self.nameLabel)
        
        //각 라이브러리의 위치를 정해주자.
            
        //네비게이션바 타이틀 설정
        self.navigationItem.title = "유저 정보 검색"
        
        //UITextfield
        self.searchBar.snp.makeConstraints {
            //view의 탑에 위치시키기 위해 top 사용
            //위에서 좀 아래에 위치하기 위해 offset사용
            //$0.top.equalToSuperview().offset(50)
            //네비게이션바 바로 밑에 설정.
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            
            //leading은 시작하는 방향 24만큼 띄워져서 시작?
            $0.leading.equalToSuperview().offset(24)
            //trailing은 끝나는 방향 -24만큼 띄워져서 끝남?
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        //UILabel
        self.nameLabel.snp.makeConstraints {
            //nameLabel의 위치는 nameTextfield의 아래에 위치하기 때문에
            $0.top.equalTo(self.searchBar.snp.bottom).offset(24)
            //좌우는 네임텍스트필드에 맞추기 위해
            //$0.leading.equalTo(self.nameTextfield)
            //$0.trailing.equalTo(self.nameTextfield)
            
            //만약 좌우를 같게 설정한다면 아래처럼 줄여서 쓸 수 있다.
            $0.leading.trailing.equalTo(self.searchBar)
        }
    }
    
}


/*
 서치 화면
 1. 선수 아이디로 검색
 2. 처음 줄 닉네임, 레벨? 정도.
 3. 현재 티어와, 최고 티어.
 4. 최근 전적.
 */


