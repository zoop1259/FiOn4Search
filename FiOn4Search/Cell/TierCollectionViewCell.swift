//
//  TierCollectionViewCell.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/31.
//

import UIKit
import Then
import SnapKit

class TierCollectionViewCell: UICollectionViewCell {
    
    let tierImgView = UIImageView().then {
        $0.image = UIImage(systemName: "swift")
    }
    
    let tierNameLabel = UILabel().then {
        $0.textAlignment = .right
        $0.text = "구단주명"
    }
    
    let tierTimeLabel = UILabel().then {
        $0.textAlignment = .right
        $0.text = "달성날짜"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
        self.configure()
    }
    
    func layout() {
//        [
//            tierImgView,
//            tierNameLabel,
//            tierTimeLabel
//        ].forEach { addSubview($0) }
        addSubview(tierImgView)
        addSubview(tierNameLabel)
        addSubview(tierTimeLabel)
    }
    
    func configure() {
        tierImgView.snp.makeConstraints {
            //view의 탑에 위치시키기 위해 top 사용
            //위에서 좀 아래에 위치하기 위해 offset사용
            //네비게이션바 바로 밑에 설정.
            $0.top.equalToSuperview().offset(5)
            //leading은 시작하는 방향 24만큼 띄워져서 시작?
            $0.leading.equalToSuperview().offset(5)
            //trailing은 끝나는 방향 -24만큼 띄워져서 끝남?
//            $0.trailing.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview().offset(-5)
            $0.height.equalTo(150)
            $0.width.equalTo(200)
        }
        
        tierNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            //$0.centerX.equalTo(tierImgView.snp.trailing).offset(5)
        }
        
        tierTimeLabel.snp.makeConstraints {
            $0.top.equalTo(tierNameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(tierNameLabel.snp.leading)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("cell init error")
    }
    
    //셀 탭시 효과없애기 찾아보기. tableview랑은 좀 다르다.
//    override func select(_ sender: Any?) {
//        super.select(sender)
//    }
    

}


