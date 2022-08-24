//
//  TierModel.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/08/09.
//

import Foundation

let search = SearchController()

// MARK: - WelcomeElement
struct TierInfo: Codable {
    let matchType, division: Int?
    let achievementDate: String
}

typealias Tier  = [TierInfo]

//슈챔
//https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/ico_rank0.png
//챔
//https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/ico_rank1.png
//슈챌
//https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/ico_rank2.png
//챌1
//https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/ico_rank3.png
//    ....
//언랭크는 다름
//https://ssl.nexon.com/s2/game/fo4/obt/rank/large/ico_rank_default.png
//이런식인듯.

//2:2
//슈챔
//https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank0.png
//챔
//https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank1.png
//2:2언랭크 링크는 다르지만 이미지는 1:1과 같긴하다.
//https://ssl.nexon.com/s2/game/fo4/obt/rank/large/2vs2/ico_rank_default.png


//func findTier(rankType: Int, tier: Int) -> (oneone: [String:String], twotwo: [String:String]){
func findTier(rankType: Int, tier: Int) -> [String:String] {
    let str = "공경 division값\(tier)"
    //key값으로 티어이름 저장.
    var oneoneTier = ""
    var twotwoTier = ""
    var oneoneImgUrl = ""
    var twotwoImgUrl = ""
    
    var tierDict = [String:String]()
    
    switch rankType {
    case 50:
        //    if rankType == 50 {
        switch tier {
        case 800:
            print("슈퍼챔피언스", str)
            tierDict = ["슈퍼챔피언스" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/update_2009/ico_ran.png"]
        case 900:
            print("챔피언스", str)
            tierDict = ["챔피언스" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/update_2009/ico_ran.png"]
        case 1000:
            print("슈퍼챌린지", str)
            tierDict = ["슈퍼챌린지" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/update_2009/ico_ran.png"]
        case 1100:
            print("챌린지1", str)
            tierDict = ["챌린지1" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/update_2009/ico_ran.png"]
        case 1200:
            print("챌린지2", str)
            tierDict = ["챌린지2" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/update_2009/ico_ran.png"]
        case 1300:
            print("챌린지3", str)
            tierDict = ["챌린지3" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/update_2009/ico_ran.png"]
        case 2000:
            print("월드클래스1", str)
            tierDict = ["월드클래스1" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/update_2009/ico_ran.png"]
        case 2100:
            print("월드클래스2", str)
            tierDict = ["월드클래스2" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/update_2009/ico_ran.png"]
        case 2200:
            print("월드클래스3", str)
            tierDict = ["월드클래스3" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/update_2009/ico_ran.png"]
        case 2300:
            print("프로1", str)
            tierDict = ["프로1" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/update_2009/ico_ran.png"]
        case 2400:
            print("프로2", str)
            tierDict = ["프로2" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/update_2009/ico_rank.png"]
        case 2500:
            print("프로3", str)
            tierDict = ["프로3" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/update_2009/ico_rank.png"]
        case 2600:
            print("세미프로1", str)
            tierDict = ["세미프로1" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/update_2009/ico_rank.png"]
        case 2700:
            print("세미프로2", str)
            tierDict = ["세미프로2" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/update_2009/ico_rank.png"]
        case 2800:
            print("세미프로3", str)
            tierDict = ["세미프로3" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/update_2009/ico_rank.png"]
        case 2900:
            print("유망주1", str)
            tierDict = ["유망주1" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/update_2009/ico_rank.png"]
        case 3000:
            print("유망주2", str)
            tierDict = ["유망주2" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/update_2009/ico_rank.png"]
        case 3100:
            print("유망주3", str)
            tierDict = ["유망주3" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/update_2009/ico_rank.png"]
        default:
            print("언랭크 ", str)
            tierDict = ["언랭크" :"https://ssl.nex.com/s2/game/fo4/obt/rank/large/ico_rank_default.png"]
        }
        
    case 52:
        //if rankType == 60 {
            switch tier {
            case 800:
                print("슈퍼챔피언스", str)
                tierDict = ["슈퍼챔피언스" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank0.png"]
            case 900:
                print("챔피언스", str)
                tierDict = ["챔피언스" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank1.png"]
            case 1000:
                print("슈퍼챌린지", str)
                tierDict = ["슈퍼챌린지" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank2.png"]
            case 1100:
                print("챌린지1", str)
                tierDict = ["챌린지1" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank3.png"]
            case 1200:
                print("챌린지2", str)
                tierDict = ["챌린지2" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank4.png"]
            case 1300:
                print("챌린지3", str)
                tierDict = ["챌린지3" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank5.png"]
            case 2000:
                print("월드클래스1", str)
                tierDict = ["월드클래스1" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank6.png"]
            case 2100:
                print("월드클래스2", str)
                tierDict = ["월드클래스2" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank7.png"]
            case 2200:
                print("월드클래스3", str)
                tierDict = ["월드클래스3" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank8.png"]
            case 2300:
                print("프로1", str)
                tierDict = ["프로1" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank9.png"]
            case 2400:
                print("프로2", str)
                tierDict = ["프로2" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank10.png"]
            case 2500:
                print("프로3", str)
                tierDict = ["프로3" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank11.png"]
            case 2600:
                print("세미프로1", str)
                tierDict = ["세미프로1" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank12.png"]
            case 2700:
                print("세미프로2", str)
                tierDict = ["세미프로2" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank13.png"]
            case 2800:
                print("세미프로3", str)
                tierDict = ["세미프로3" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank14.png"]
            case 2900:
                print("유망주1", str)
                tierDict = ["유망주1" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank15.png"]
            case 3000:
                print("유망주2", str)
                tierDict = ["유망주2" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank16.png"]
            case 3100:
                print("유망주3", str)
                tierDict = ["유망주3" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/2vs2/ico_rank17.png"]
            default:
                print("언랭크 ", str)
                tierDict = ["언랭크" :  "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/2vs2/ico_rank_default.png"]
            }
    default:
        tierDict = ["언랭크" : "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/2vs2/ico_rank_default.png"]
    }
    return tierDict
    }
 
            
            


/*
 [
         {
                 "divisionId": 800,
                 "divisionName": "슈퍼챔피언스"
         },
         {
                 "divisionId": 900,
                 "divisionName": "챔피언스"
         },
         {
                 "divisionId": 1000,
                 "divisionName": "슈퍼챌린지"
         },
         {
                 "divisionId": 1100,
                 "divisionName": "챌린지1"
         },
         {
                 "divisionId": 1200,
                 "divisionName": "챌린지2"
         },
         {
                 "divisionId": 1300,
                 "divisionName": "챌린지3"
         },
         {
                 "divisionId": 2000,
                 "divisionName": "월드클래스1"
         },
         {
                 "divisionId": 2100,
                 "divisionName": "월드클래스2"
         },
         {
                 "divisionId": 2200,
                 "divisionName": "월드클래스3"
         },
         {
                 "divisionId": 2300,
                 "divisionName": "프로1"
         },
         {
                 "divisionId": 2400,
                 "divisionName": "프로2"
         },
         {
                 "divisionId": 2500,
                 "divisionName": "프로3"
         },
         {
                 "divisionId": 2600,
                 "divisionName": "세미프로1"
         },
         {
                 "divisionId": 2700,
                 "divisionName": "세미프로2"
         },
         {
                 "divisionId": 2800,
                 "divisionName": "세미프로3"
         },
         {
                 "divisionId": 2900,
                 "divisionName": "유망주1"
         },
         {
                 "divisionId": 3000,
                 "divisionName": "유망주2"
         },
         {
                 "divisionId": 3100,
                 "divisionName": "유망주3"
         }
 ]
 
 */

/*
 func findTier(rankType: Int, tier: Int) -> [String:String] {
     let str = "공경 division값\(tier)"
     print(str)
     var tierName = ""
     var tierImg = ""
     var tierDict : [String:String]
     
     if rankType == 50 {
         switch tier {
         case 800:
             tierName = "슈퍼챔피언스"
             tierImg = "https://ssl.nexon.com/s2/game/fo4/obt/rank/large/update_2009/ico_rank0.png"
             //return [tierName:tierImg]
         default :
             return [tierName:tierImg]
         }
     }
     return [tierName:tierImg]
 }

 //print(findTier(rankType: 50, tier: 800))

 findTier(rankType: 50, tier: 800)
 */
