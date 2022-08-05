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
    //세그먼트 목록
    let items = ["PC(30%)", "TOP(20%)", "PC+TOP(50%)"]
    
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
        //라이브러리의 제약조건
        $0.setContentCompressionResistancePriority(.init(rawValue: 749), for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    let cashstackView = UIStackView().then {
        $0.backgroundColor = .white
        //$0.alignment = .center
        $0.spacing = 10
    }
    
    let commissionTextField = UITextField().then {
        $0.placeholder = "수수료 쿠폰 %"
        $0.textColor = .black
        $0.borderStyle = .bezel
        $0.textAlignment = .right
    }
    
    let commissionLabel = UILabel().then {
        $0.sizeToFit()
        $0.font = .systemFont(ofSize: 20)
        $0.layer.borderWidth = 0.5
        $0.text = "수수료%"
        $0.layer.borderColor = UIColor.black.cgColor
        $0.textAlignment = .left
        //라이브러리의 제약조건
        $0.setContentCompressionResistancePriority(.init(rawValue: 749), for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
    }
    
    let commissionstackView = UIStackView().then {
        $0.backgroundColor = .white
        //$0.alignment = .center
        $0.spacing = 10
    }

    let discountamountTextField = UITextField().then {
        $0.placeholder = "할인금액"
        $0.textColor = .black
        $0.borderStyle = .bezel
        $0.textAlignment = .right
    }
    
    let discountamountLabel = UILabel().then {
        $0.sizeToFit()
        $0.font = .systemFont(ofSize: 20)
        $0.layer.borderWidth = 0.5
        $0.text = "할인금액"
        $0.layer.borderColor = UIColor.black.cgColor
        $0.textAlignment = .left
        //라이브러리의 제약조건
        $0.setContentCompressionResistancePriority(.init(rawValue: 749), for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    let discountamountstackView = UIStackView().then {
        $0.backgroundColor = .white
        //$0.alignment = .center
        $0.spacing = 10
    }
    
    let receiveTextField = UITextField().then {
        $0.placeholder = "받을금액"
        $0.textColor = .black
        $0.borderStyle = .bezel
        $0.textAlignment = .right
    }
    
    let receiveLabel = UILabel().then {
        $0.sizeToFit()
        $0.font = .systemFont(ofSize: 20)
        $0.layer.borderWidth = 0.5
        $0.text = "받을금액"
        $0.layer.borderColor = UIColor.black.cgColor
        $0.textAlignment = .left
        //라이브러리의 제약조건
        $0.setContentCompressionResistancePriority(.init(rawValue: 749), for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    let receivestackView = UIStackView().then {
        $0.backgroundColor = .white
        //$0.alignment = .center
        $0.spacing = 10
    }
    
    let cancelBtn = UIButton().then {
        $0.tintColor = .black
        $0.backgroundColor = .white
        $0.setTitle("초기화", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    //목록을 위해 생성한 arr items를 넣어주려면 lazy var로 바꿔줘야한다.
    lazy var discountSegControl = UISegmentedControl(items: items).then {
        $0.backgroundColor = .gray
        $0.tintColor = .white
    }
    
    
    
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        cashTextField.delegate = self
        commissionTextField.delegate = self
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnTapped), for: .touchUpInside)
    }
    
    
    //MARK: - configure
    func configure() {
        //요소가 보이는 부분은 view다.
        //addSubView는 매개변수로 추가할 뷰를 받는다.
        //class안에서 생성한 라이브러리기 때문에 self를 사용해주어야한다.
        view.addSubview(self.navigationBar)
        view.addSubview(self.cashstackView)
        cashstackView.addArrangedSubview(self.cashLabel)
        cashstackView.addArrangedSubview(self.cashTextField)
        
        view.addSubview(self.commissionstackView)
        commissionstackView.addArrangedSubview(self.commissionLabel)
        commissionstackView.addArrangedSubview(self.commissionTextField)
        
        view.addSubview(self.discountamountstackView)
        discountamountstackView.addArrangedSubview(self.discountamountLabel)
        discountamountstackView.addArrangedSubview(self.discountamountTextField)
        
        view.addSubview(self.receivestackView)
        receivestackView.addArrangedSubview(self.receiveLabel)
        receivestackView.addArrangedSubview(self.receiveTextField)
        
        view.addSubview(self.cancelBtn)
        view.addSubview(self.discountSegControl)
        
        //네비게이션바 타이틀 설정
        self.navigationItem.title = "이적 시장 계산기"
        
        //stackview
        self.cashstackView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        self.commissionstackView.snp.makeConstraints {
            $0.top.equalTo(self.cashstackView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(self.cashstackView)
        }
        self.discountamountstackView.snp.makeConstraints {
            $0.top.equalTo(self.discountSegControl.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(self.cashstackView)
        }
        self.receivestackView.snp.makeConstraints {
            $0.top.equalTo(self.discountamountstackView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(self.cashstackView)
        }
        
        //segmentcontol
        self.discountSegControl.snp.makeConstraints {
            $0.top.equalTo(self.commissionstackView.snp.bottom).offset(10)
            $0.leading.equalTo(self.commissionstackView)
        }
        
        //button
        self.cancelBtn.snp.makeConstraints {
            $0.top.equalTo(self.receivestackView.snp.bottom).offset(10)
            $0.leading.equalTo(self.receivestackView)
        }
    }
    
    //MARK: - CancelBtn
    @objc func cancelBtnTapped() {
        print("초기화버튼 터치됨")
        self.cashTextField.text = nil
        self.commissionTextField.text = nil
    }
    
    
    
}

//MARK: - TextFieldDelegate
extension CommissionController: UITextFieldDelegate {
    
    //터치시 플레이스홀더 지우기.
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.placeholder = nil
//    }
//    //입력이 없을시 플레이스홀더 되돌리기.
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField.text!.count == 0 {
//            textField.placeholder = "선수금액"
//        }
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // replacementString : 방금 입력된 문자 하나, 붙여넣기 시에는 붙여넣어진 문자열 전체
        // return -> 텍스트가 바뀌어야 한다면 true, 아니라면 false
        // 이 메소드 내에서 textField.text는 현재 입력된 string이 붙기 전의 string
        
        //,를 붙이기 위한 메서드
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
