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
    //만약 날짜가 없다면 그냥 현재날짜로 표시.
    let convertDate = dateFormatter.date(from: inputDate) ?? Date() // Date 타입으로 변환
    let myDateFormatter = DateFormatter()
    myDateFormatter.dateFormat = "yyyy.MM.dd a hh시 mm분" // 2020.08.13 오후 04시 30분
    myDateFormatter.locale = Locale(identifier:"ko_KR") // PM, AM을 언어에 맞게 setting (ex: PM -> 오후)
    let convertStr = myDateFormatter.string(from: convertDate)
    //print(convertStr)
    //let convertNowStr = myDateFormatter.string(from: nowDate) // 현재 시간의 Date를 format에 맞춰 string으로 반환
    
    return convertStr
    
}

func changeValue(_ change: String?) -> String {
    var returnValue = ""

    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal // 1,000,000
    formatter.locale = Locale.current
    formatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수

    if let receiveChange = change {
        if let changeInt = Int(receiveChange) {
            returnValue = formatter.string(from: NSNumber(value: changeInt)) ?? ""
        }
    }
    return returnValue
}

func format(number: Int) -> String {
    let format = NumberFormatter()
    format.numberStyle = .decimal
//        format.groupingSize = 3
    return format.string(from: NSNumber(value: number))!
}
