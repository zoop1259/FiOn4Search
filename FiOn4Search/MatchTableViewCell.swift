//
//  MatchTableViewCell.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/31.
//

import UIKit
import Then
import SnapKit

class MatchTableViewCell: UITableViewCell {

    //매칭시간
    let matchDateLabel = UILabel().then {
        $0.textAlignment = .center
    }
    
    //홈 이름 결과 골수
    let homeNameLabel = UILabel().then {
        $0.textAlignment = .left
        $0.text = "홈이름"
    }
    let homeResultLabel = UILabel().then {
        $0.textAlignment = .left
        $0.text = "홈결과"
    }
    let homeGoalLabel = UILabel().then {
        $0.textAlignment = .right
        $0.text = "0"
    }
    
    //어웨이
    let awayNameLabel = UILabel().then {
        $0.textAlignment = .right
        $0.text = "어웨이"
    }
    let awayResultLabel = UILabel().then {
        $0.textAlignment = .right
        $0.text = "어웨이결과"
    }
    let awayGoalLabel = UILabel().then {
        $0.textAlignment = .left
        $0.text = "0"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("cell init error")
    }
    
    func layout() {
//        self.addSubview(matchDateLabel)
//        self.addSubview(homeNameLabel)
//        self.addSubview(homeResultLabel)
//        self.addSubview(homeGoalLabel)
//
//        self.addSubview(awayNameLabel)
//        self.addSubview(awayResultLabel)
//        self.addSubview(awayGoalLabel)
        //이런 방법도 가능.
        [
            matchDateLabel,
            homeNameLabel,
            homeResultLabel,
            homeGoalLabel,
            awayNameLabel,
            awayResultLabel,
            awayGoalLabel
        ].forEach { addSubview($0) }
        
    }
    
    func configure() {
        //매칭시간
        //이름 승 1 : 0 패 이름
        //이런식으로 하고 싶긴하다.
        matchDateLabel.snp.makeConstraints {
            //view의 탑에 위치시키기 위해 top 사용
            //위에서 좀 아래에 위치하기 위해 offset사용
            //네비게이션바 바로 밑에 설정.
            $0.top.equalToSuperview()
            //leading은 시작하는 방향 24만큼 띄워져서 시작?
            $0.leading.equalToSuperview().offset(5)
            //trailing은 끝나는 방향 -24만큼 띄워져서 끝남?
            $0.trailing.equalToSuperview().offset(-5)
//            self.searchBtn.snp.makeConstraints {
//                $0.width.equalTo(50)
//            }
        }
        
        homeResultLabel.snp.makeConstraints {
            $0.top.equalTo(self.matchDateLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(5)
        }
        homeNameLabel.snp.makeConstraints {
            $0.top.equalTo(self.matchDateLabel.snp.bottom)
            $0.leading.equalTo(self.homeResultLabel.snp.trailing).offset(5)
        }
        homeGoalLabel.snp.makeConstraints {
            $0.top.equalTo(self.matchDateLabel.snp.bottom)
            $0.leading.equalTo(self.homeNameLabel.snp.trailing).offset(5)
        }
        
        awayResultLabel.snp.makeConstraints {
            $0.top.equalTo(self.matchDateLabel.snp.bottom)
            $0.trailing.equalToSuperview().offset(-5)
        }
        awayNameLabel.snp.makeConstraints {
            $0.top.equalTo(self.matchDateLabel.snp.bottom)
            $0.trailing.equalTo(self.awayResultLabel.snp.leading).offset(-5)
        }
        awayGoalLabel.snp.makeConstraints {
            $0.top.equalTo(self.matchDateLabel.snp.bottom)
            $0.trailing.equalTo(self.awayNameLabel.snp.leading).offset(-5)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("\(homeNameLabel.text) : \(homeResultLabel.text)")
        // Configure the view for the selected state
    }

    
    
}
