//
//  CityInfo.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/10/18.
//

import Foundation

struct CityInformation: Codable {
    let code: String
    let province: String
    let city: String
    let airCoditionMeasuring: String
    let xCoordination: Int
    let yCoordination: Int
    let longitude: Double
    let latitude: Double
}

// 도시 정보를 찾을 때 사용하는 모델
struct SearchingLocation {
    var locationString: String
    let locationCode: String
}
