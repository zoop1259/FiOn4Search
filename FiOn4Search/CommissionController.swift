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
import RxSwift
import RxCocoa

class CommissionController: UIViewController {
    
    //네비게이션아이템은 네비게이션바안에 있기 떄문에 이곳에서 직접 설정은 불가능 하다.
    let navigationBar = UINavigationBar()
    //세그먼트 목록
    let items = ["PC(30%)", "TOP(20%)", "PC+TOP(50%)"]
    private var bag = DisposeBag()
    
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
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    let cashstackView = UIStackView().then {
        $0.backgroundColor = .white
        //$0.alignment = .center
        $0.spacing = 10
    }
    
    let couponTextField = UITextField().then {
        $0.placeholder = "수수료 쿠폰 %"
        $0.textColor = .black
        $0.borderStyle = .bezel
        $0.textAlignment = .right
    }
    
    let couponLabel = UILabel().then {
        $0.sizeToFit()
        $0.font = .systemFont(ofSize: 20)
        $0.layer.borderWidth = 0.5
        $0.text = "수수료%"
        $0.layer.borderColor = UIColor.black.cgColor
        $0.textAlignment = .left
        //라이브러리의 제약조건
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
    }
    
    let couponstackView = UIStackView().then {
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
        //$0.setContentCompressionResistancePriority(.init(rawValue: 749), for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    let receivestackView = UIStackView().then {
        $0.backgroundColor = .white
        //$0.alignment = .center
        $0.spacing = 10
    }
    
    lazy var cancelBtn = UIButton().then {
        $0.tintColor = .black
        $0.backgroundColor = .white
        $0.setTitle("초기화", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.frame.size.height = 50
    }
    
    //목록을 위해 생성한 arr items를 넣어주려면 lazy var로 바꿔줘야한다.
    lazy var discountSegControl = UISegmentedControl(items: items).then {
        $0.backgroundColor = .gray
        $0.tintColor = .white
    }
    
//    lazy var asdstackView = UIStackView(arrangedSubviews: [asdasd])
    
    let asdView = UIView().then {
        $0.addSubview(UILabel().then {
            $0.text = "안나왕...."
        })
        $0.addSubview(UITextField().then {
            $0.placeholder = "안나왕..."
        })
    }
    
    //텍스트필드 인트형?
//    let a:Int? = Int(firstText.text)
//    min = Int(minutes.text ?? "") ?? 0
    
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        cashTextField.delegate = self
        
    
        //이벤트가 발생했을 때
        couponTextField.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe(onNext: {_ in
                print("터치되었다")
            }).disposed(by: bag)

        //다른 텍스트필드에의해 바뀔떈 호출안된다.
//        receiveTextField.rx.controlEvent([.editingChanged])
//            .asObservable()
//            .subscribe(onNext: {_ in
//                print("변경되었다")
//            }).disposed(by: bag)

        
        //textfield.rx.text의 변경이 있을 때
//        receiveTextField.rx.text
//            .subscribe(onNext: { newValue in
//                print("리시브변경됨")
//                //self.receiveTextField.text = self.changeValue(self.receiveTextField.text)
//            print(newValue)
//            }).disposed(by: bag)
        
        //textfield.text의 변경이 있을 때
        cashTextField.rx.observe(String.self, "text")
            .subscribe(onNext: {_ in
                //입력이 될때마다 culc호출.
                self.culc()
            }).disposed(by: bag)
        
        couponTextField.rx.observe(String.self, "text")
            .subscribe(onNext: {count in
                if let count = self.couponTextField.text {
                    self.couponCount(count)
                    self.culc()
                }
            }).disposed(by: bag)
        
        discountSegControl.rx.selectedSegmentIndex
            .subscribe(onNext: {_ in
                print("segcontrol 인덱스 값이 변경됨")
                self.culc()
            }).disposed(by: bag)
        
        receiveTextField.rx.observe(String.self, "text")
            .subscribe(onNext: {newValue in
                //입력이 될때마다 culc호출.
                print("받을금액 변경됨")
            }).disposed(by: bag)
        
        cancelBtn.rx.tap
            .subscribe(onNext: {_ in
                self.cashTextField.text = nil
                self.couponTextField.text = nil
                self.discountamountTextField.text = nil
                self.receiveTextField.text = nil
            }).disposed(by: bag)
        
    }
    
    func couponCount(_ count: String) {
        //100퍼 이상 할인은 없기 떄문에 2자리수로 제한.
        if count.count > 2 {
            let index = count.index(count.startIndex, offsetBy: 2)
            self.couponTextField.text = String(count[..<index])
        }
    }
    
    func culc() {
        var cash = 0
        var culc = 0
        //,를 줄이기 위해.
        let filtered = self.cashTextField.text?.description.replacingOccurrences(of: ",", with: "")
        
        if let personcash = filtered {
            
            if let filtercash = Double(personcash) {
                print(filtercash)
                let baseCommission = Int(filtercash * 0.6)
                culc = baseCommission
            }
        }

        if let coupontext = self.couponTextField.text {
            if let useCoupon = Double(coupontext) {
                //기본 수수료는 40% , 그러니 기본으로 받는가격은 60%
                //let commission = Double(filtercash * 0.4)
                //let culcCash = commission * useCoupon

            }
        }
        
        self.receiveTextField.text = String(culc)
        
        //받을금액 , 찍기
        var returnValue = ""
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 1,000,000
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수
        if let receiveChange = self.receiveTextField.text {
            if let changeInt = Int(receiveChange) {
                returnValue = formatter.string(from: NSNumber(value: changeInt))!
            }
        }
        self.receiveTextField.text = returnValue
        
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
        
        view.addSubview(self.couponstackView)
        couponstackView.addArrangedSubview(self.couponLabel)
        couponstackView.addArrangedSubview(self.couponTextField)
        
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
        
        //MARK: - makeConstraints
        self.cashstackView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        self.couponstackView.snp.makeConstraints {
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
        
        self.discountSegControl.snp.makeConstraints {
            $0.top.equalTo(self.couponstackView.snp.bottom).offset(10)
            $0.leading.equalTo(self.couponstackView)
        }
        
        self.cancelBtn.snp.makeConstraints {
            $0.top.equalTo(self.receivestackView.snp.bottom).offset(10)
            $0.leading.equalTo(self.receivestackView)
        }
        
//        view.addSubview(self.asdView)
//        self.asdView.snp.makeConstraints {
//            $0.top.equalTo(self.cancelBtn.snp.bottom).offset(10)
//            $0.leading.equalTo(self.receivestackView)
//            $0.height.equalTo(50)
//        }
    }
}

//MARK: - TextFieldDelegate
extension CommissionController: UITextFieldDelegate {
    
    //터치시 플레이스홀더 지우기.
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.placeholder = nil
//    }
    //입력이 없을시 플레이스홀더 되돌리기.
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField.text!.count == 0 {
//            textField.placeholder = "선수금액"
//        }
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //숫자용 키패드
        textField.keyboardType = .decimalPad
        
        //단순히 숫자만 입력받기
//        let allowedCharacters = CharacterSet.decimalDigits
//        let characterSet = CharacterSet(charactersIn: string)
//        return allowedCharacters.isSuperset(of: characterSet)

        
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
