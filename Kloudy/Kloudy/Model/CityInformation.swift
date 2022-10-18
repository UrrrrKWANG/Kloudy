//
//  CityInfo.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/10/18.
//

import Foundation

struct CityInformation {
    let name: String
    let x: Int
    let y: Int
}

// 군들이 빠져있음 -> 나중에 엑셀파일에서 긁어오겠음
let koreaCitySamples: [CityInformation] = [
    CityInformation(name: "서울시", x: 60, y: 127),
    CityInformation(name: "인천시", x: 55, y: 124),
    CityInformation(name: "수원시", x: 60, y: 121)
]
