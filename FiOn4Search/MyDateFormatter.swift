//
//  MyDateFormatter.swift
//  FiOn4Search
//
//  Created by 강대민 on 2022/09/21.
//

import Foundation

func changeDate(inputDate : String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let convertDate = dateFormatter.date(from: inputDate) // Date 타입으로 변환
    let myDateFormatter = DateFormatter()
    myDateFormatter.dateFormat = "yyyy.MM.dd a hh시 mm분" // 2020.08.13 오후 04시 30분
    myDateFormatter.locale = Locale(identifier:"ko_KR") // PM, AM을 언어에 맞게 setting (ex: PM -> 오후)
    let convertStr = myDateFormatter.string(from: convertDate!)
    //print(convertStr)
    //let convertNowStr = myDateFormatter.string(from: nowDate) // 현재 시간의 Date를 format에 맞춰 string으로 반환
    
    return convertStr
    
}
