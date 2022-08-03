//
//  TopPlayer.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/03.
//

import UIKit
//UIKit과 한줄 띄우는게 좋으며 라이브러리 a-z순으로 import해주는게 협업에 편할것이다.
import SnapKit //오토레이아웃 설정에 용이한 오픈소스
import Then    //라이브러리 설정에 용이한 오픈소스



class TopPlayerController: UIViewController {

    //스토리보드로 라이브러리를 추가하는게 아니라 코드로 라이브러리를 추가해줘야하기 때문에.
    //let 이름 = 라이브러리이름 후에 () 로 개체로 만든다.
    
    //네비게이션아이템은 네비게이션바안에 있기 떄문에 이곳에서 직접 설정은 불가능 하다.
    let navigationBar = UINavigationBar().then {
        let naviItem = UINavigationItem(title: "인기선수")
        $0.setItems([naviItem], animated: true)
    }
    
    let nameTextfield = UITextField().then {
        $0.placeholder = "유저닉네임?"
        $0.textColor = .blue
    }
    let nameLabel = UILabel().then {
        $0.text = "유저닉네임"
        $0.textAlignment = .center
        $0.textColor = .lightGray
    }
    let searchBtn = UIButton().then {
        $0.tintColor = .black
        $0.backgroundColor = .white
        $0.setTitle("검색", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
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
        view.addSubview(self.nameLabel)
        view.addSubview(self.nameTextfield)
        view.addSubview(self.searchBtn)
        view.addSubview(self.navigationBar)
        
        //각 라이브러리의 위치를 정해주자.
    
        //네비게이션바
        self.navigationBar.snp.makeConstraints {
            $0.top.equalTo(UIView())
        }
        
        //UITextfield
        self.nameTextfield.snp.makeConstraints {
            //view의 탑에 위치시키기 위해 top 사용
            //위에서 좀 아래에 위치하기 위해 offset사용
            $0.top.equalToSuperview().offset(50)
            //leading은 시작하는 방향 24만큼 띄워져서 시작?
            $0.leading.equalToSuperview().offset(24)
            //trailing은 끝나는 방향 -24만큼 띄워져서 끝남?
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        //UIButton
        //클래스 내에서 선언한 버튼이라 self를 사용하고
        //snapkit을 통해 위치를 잡아줄것이기 때문에 snp사용
        //위치를 잡아주기위한 makeConstrataints를 사용
        self.searchBtn.snp.makeConstraints {
            //우선 뷰의 정중앙에 위치시키기 위해 center사용.
            $0.center.equalToSuperview()
            //였지만 텍스트필드 옆에 보내기 위해.
            //$0.top.equalTo(self.nameTextfield)
            //$0.leading.equalTo(self.nameTextfield.snp.trailing).offset(10)
        }
        
        //UILabel
        self.nameLabel.snp.makeConstraints {
            //nameLabel의 위치는 nameTextfield의 아래에 위치하기 때문에
            $0.top.equalTo(self.nameTextfield.snp.bottom).offset(24)
            //좌우는 네임텍스트필드에 맞추기 위해
            //$0.leading.equalTo(self.nameTextfield)
            //$0.trailing.equalTo(self.nameTextfield)
            
            //만약 좌우를 같게 설정한다면 아래처럼 줄여서 쓸 수 있다.
            $0.leading.trailing.equalTo(self.nameTextfield)
        }
    }
    
}
