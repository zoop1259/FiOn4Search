//
//  CommissionController.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/03.
//

import UIKit
//UIKit과 한줄 띄우는게 좋으며 a-z순으로 import해주는게 협업에 편할것이다.
import SnapKit //오토레이아웃 설정에 용이한 오픈소스
import Then    //라이브러리 설정에 용이한 오픈소스



class CommissionController: UIViewController {
    
    //네비게이션아이템은 네비게이션바안에 있기 떄문에 이곳에서 직접 설정은 불가능 하다.
    let navigationBar = UINavigationBar()
    
    let cashTextField = UITextField().then {
        $0.placeholder = "선수금액"
        $0.textColor = .black
        $0.borderStyle = .bezel
        $0.textAlignment = .right
    }
    
    let cashLabel = UILabel().then {
        $0.sizeToFit()
        $0.font = .systemFont(ofSize: 20)
        $0.layer.borderWidth = 0.5
        $0.text = "선수금액"
        $0.layer.borderColor = UIColor.black.cgColor
        $0.textAlignment = .left
        $0.setContentCompressionResistancePriority(.init(rawValue: 749), for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
    }
    
    let cashstackView = UIStackView().then {
        $0.backgroundColor = .white
        //$0.alignment = .center
        $0.spacing = 10
    }
    
    let commissionTextField = UITextField().then {
        $0.placeholder = "수수로입력"
        $0.textColor = .black
    }
    let cancelBtn = UIButton().then {
        $0.tintColor = .black
        $0.backgroundColor = .white
        $0.setTitle("검색", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        cashTextField.delegate = self
        
    }
    
    
    //MARK: - configure
    func configure() {
        //요소가 보이는 부분은 view다.
        //addSubView는 매개변수로 추가할 뷰를 받는다.
        //class안에서 생성한 라이브러리기 때문에 self를 사용해주어야한다.
        view.addSubview(self.cashstackView)
        view.addSubview(self.navigationBar)
//        view.addSubview(self.cashLabel)
//        view.addSubview(self.cashTextField)
        cashstackView.addArrangedSubview(self.cashLabel)
        cashstackView.addArrangedSubview(self.cashTextField)
        
        view.addSubview(self.commissionTextField)
        view.addSubview(self.cancelBtn)
        
        //네비게이션바 타이틀 설정
        self.navigationItem.title = "수수로 계산기"
        
        //라이브러리의 제약조건
//        self.cashLabel.setContentCompressionResistancePriority(.init(rawValue: 749), for: .horizontal)
//        self.cashLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        //각 라이브러리의 위치를 정해주자.
//
//        //UILabel
//        self.cashLabel.snp.makeConstraints {
//            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(30)
//            $0.leading.equalToSuperview().offset(24)
//        }
//
//        //UITextfield
//        self.cashTextField.snp.makeConstraints {
//            //네비게이션바 바로 밑에 설정.
//            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(30)
//
//            //leading은 시작하는 방향 24만큼 띄워져서 시작?
//            $0.leading.equalTo(self.cashLabel.snp.trailing).offset(24)
//            //trailing은 끝나는 방향 -24만큼 띄워져서 끝남?
//            $0.trailing.equalToSuperview().offset(-24)
//        }
        
        //stackview
        self.cashstackView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        //UILabel
//        self.commissionTextField.snp.makeConstraints {
//            //nameLabel의 위치는 nameTextfield의 아래에 위치하기 때문에
//            $0.top.equalTo(self.cashTextField.snp.bottom).offset(24)
//
//            $0.leading.trailing.equalTo(self.cashTextField)
//        }
        //초기화버튼은 나중에 추가하도록 하자.
//        self.cancelBtn
        
    }
    
}

extension CommissionController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // replacementString : 방금 입력된 문자 하나, 붙여넣기 시에는 붙여넣어진 문자열 전체
        // return -> 텍스트가 바뀌어야 한다면 true, 아니라면 false
        // 이 메소드 내에서 textField.text는 현재 입력된 string이 붙기 전의 string
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 1,000,000
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수
        
        // formatter.groupingSeparator // .decimal -> ,
        
        if let removeAllSeprator = textField.text?.replacingOccurrences(of: formatter.groupingSeparator, with: ""){
            var beforeForemattedString = removeAllSeprator + string
            if formatter.number(from: string) != nil {
                if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                    textField.text = formattedString
                    return false
                }
            }else{ // 숫자가 아닐 때먽
                if string == "" { // 백스페이스일때
                    let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
                    beforeForemattedString = String(beforeForemattedString[..<lastIndex])
                    if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                        textField.text = formattedString
                        return false
                    }
                }else{ // 문자일 때
                    return false
                }
            }

        }
        
        return true
    }
}
