//
//  CommissionController.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/03.
//

import UIKit
import SnapKit //오토레이아웃 설정에 용이한 오픈소스
import Then    //라이브러리 설정에 용이한 오픈소스
import RxSwift
import RxCocoa

//후에 선수들의 값이 더 높아지면 Int64나 UInt를 써야할거같다.
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
        $0.keyboardType = .decimalPad
        //textField.keyboardType = .decimalPad
        
        //숫자패드로 사용하기. 허나 이렇게하면 각 textfield에 추가해줘야한다.
        //그래서 delegate에 한줄로 해결?...?.....그렇다기엔 delegate등록도 어차피 해야되니까..음...
        //근데 다른용도로 쓰는 textfield가 존재할시엔 이렇게 따로 설정해주는게 맞는거같다.
        //$0.keyboardType = .numberPad
    }
    
    let cashLabel = UILabel().then {
        $0.sizeToFit()
        $0.font = .systemFont(ofSize: 20)
        $0.layer.borderWidth = 0.5
        $0.text = "선수금액"
        $0.layer.borderColor = UIColor.black.cgColor
        $0.textAlignment = .left
        $0.layer.cornerRadius = 5.0
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowRadius = 10
        //라이브러리의 제약조건
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    let cashstackView = UIStackView().then {
        $0.backgroundColor = .white
        //$0.alignment = .center
        $0.spacing = 10
    }
    
    let couponTextField = UITextField().then {
        $0.placeholder = "수수료 쿠폰 % (Max: 50%)"
        $0.textColor = .black
        $0.borderStyle = .bezel
        $0.textAlignment = .right
        $0.keyboardType = .decimalPad
    }
    
    let couponLabel = UILabel().then {
        $0.sizeToFit()
        $0.font = .systemFont(ofSize: 20)
        $0.layer.borderWidth = 0.5
        $0.text = "수수료%"
        $0.layer.borderColor = UIColor.black.cgColor
        $0.textAlignment = .left
        $0.layer.cornerRadius = 5.0
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowRadius = 10
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
        //터치시 입력 방지.
        $0.isUserInteractionEnabled = false
        $0.keyboardType = .decimalPad
    }
    
    let discountamountLabel = UILabel().then {
        $0.sizeToFit()
        $0.font = .systemFont(ofSize: 20)
        $0.layer.borderWidth = 0.5
        $0.text = "할인금액"
        $0.layer.borderColor = UIColor.black.cgColor
        $0.textAlignment = .left
        $0.layer.cornerRadius = 5.0
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowRadius = 10
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
        $0.isUserInteractionEnabled = false
    }
    
    let receiveLabel = UILabel().then {
        $0.sizeToFit()
        $0.font = .systemFont(ofSize: 20)
        $0.layer.borderWidth = 0.5
        $0.text = "받을금액"
        $0.layer.borderColor = UIColor.black.cgColor
        $0.textAlignment = .left
        $0.layer.cornerRadius = 5.0
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowRadius = 10
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
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.cornerRadius = 5.0
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowRadius = 10
    }
    
    //목록을 위해 생성한 arr items를 넣어주려면 lazy var로 바꿔줘야한다.
    lazy var discountSegControl = UISegmentedControl(items: items).then {
        $0.backgroundColor = .gray
        $0.tintColor = .white
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
        bind()

    }
    
    func bind() {
        let getcashText = BehaviorRelay<String>(value: "")
        
        //값 변경 감지.
        cashTextField.rx.text.orEmpty
            //값이 변경됐을'때만' 호출.
            .distinctUntilChanged()
            //첫 이벤트 스킵.
            .skip(1)
            .subscribe(onNext: { newValue in
                print("cashText가 변경됨 :", newValue)
                //self.culc()
                let sort = newValue.filter("0123456789.".contains)
                if let intValue = Int(sort) {
                       self.cashTextField.text = format(number: intValue)
                }
            }).disposed(by: bag)
        
        cashTextField.rx.text.orEmpty
            .bind(to: getcashText)
            .disposed(by: bag)
        
        couponTextField.rx.text.orEmpty
            //.distinctUntilChanged()
            .skip(1)
            .subscribe(onNext: { count in
                print("couponTextField가 변경됨 :", count)
                self.couponCount(count)
                self.culc()
                
            }, onCompleted: {print("완료됨")}).disposed(by: bag)
        
        //선택이 안됐을때도 호출이 되네..
        discountSegControl.rx.selectedSegmentIndex
            .skip(1)
            .subscribe(onNext: {index in
                print("segcontrol 인덱스 값이 변경됨 : ", index)
                self.culc()
            }).disposed(by: bag)
        
        //취소버튼 눌렀을때
        cancelBtn.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.cashTextField.text = nil
                self.couponTextField.text = nil
                self.discountamountTextField.text = nil
                self.receiveTextField.text = nil
                self.discountSegControl.selectedSegmentIndex = -1
            }).disposed(by: bag)
    }
    
    
    //MARK: - 여기서부터 계산에 필요한 함수들
    func couponCount(_ count: String) {
        //100퍼 이상 할인은 없기 떄문에 2자리수로 제한.
        if count.count > 2 {
            let index = count.index(count.startIndex, offsetBy: 2)
            self.couponTextField.text = String(count[..<index])
        }
        
        //게다가 현재는 50퍼 할인이 끝이기 떄문에.
        if let count = Int(count) {
            if count > 50 {
                self.couponTextField.text = String("50")
            }
        }
    }
    
    //MARK: - culc
    func culc() {
        var cash = 0
        var culc = 0
        var coupon:Double = 0
        var segValue:Double = 0
        var commission:Double = 0
        var basicValue = 0
        //,를 줄이기 위해.
        let filtered = self.cashTextField.text?.description.replacingOccurrences(of: ",", with: "")
        let segfiltered = self.discountSegControl.selectedSegmentIndex
        if segfiltered == 0 {
            segValue = 0.3
        } else if segfiltered == 1 {
            segValue = 0.2
        } else if segfiltered == 2 {
            segValue = 0.5
        } else { segValue = 0 }
        //print(segfiltered)
        //print(segValue)
        
        //기본 수수료를 계산한 가격 구하기.
        if let personcash = filtered {
            if let filtercash = Double(personcash) {
                //print(filtercash)
                let baseprice = Int(filtercash * 0.6)
                let baseCommission = Double(filtercash * 0.4)
                basicValue = Int(baseCommission)
                culc = baseprice
                commission = baseCommission
            }
        }

        //입력받은 수수료 쿠폰값을 저장.
        if let coupontext = self.couponTextField.text {
            if let useCoupon = Double(coupontext) {
                coupon = useCoupon / 100
                //기본 수수료는 40% , 그러니 기본으로 받는가격은 60%
//                let commission = Double(filtercash * 0.4)
                //let culcCash = commission * useCoupon
                //수수료자체 할인인것. 예를들어 수수료가 4천만원인 상태에서 50퍼 쿠폰을쓰면 수수료 2천만 할인.
            }
        }
        
        let discount = Int(commission * (coupon + segValue))
        cash = culc + discount
        
        //초기값 플레이스홀더
        if culc == 0 {
            self.discountamountTextField.text = nil
            self.receiveTextField.text = nil
        } else if Int(coupon + segValue) == 1 {
            self.receiveTextField.text = self.cashTextField.text
            self.discountamountTextField.text = changeValue(String(basicValue))
        } else {
            self.discountamountTextField.text = changeValue(String(discount))
            self.receiveTextField.text = changeValue(String(cash))
        }
         
        
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
            //$0.leading.equalTo(self.couponstackView)
            $0.centerX.equalToSuperview()
        }
        
        self.cancelBtn.snp.makeConstraints {
            $0.top.equalTo(self.receivestackView.snp.bottom).offset(10)
            $0.leading.equalTo(self.receivestackView)
        }
        
    }
    
    //키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
}


//MARK: - TextFieldDelegate
extension CommissionController: UITextFieldDelegate {
    
    //이 로직을 어떻게 rx로 구현할것인가.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //현재 100경까지만. 나중에 선수값이 기하급수적으로 오르면 culc에서 int를 수정해야함.
        if textField.text?.count ?? 0 >= 25 {
            return false
        }
        return true
    }
         
}
