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
}

// 도시 정보를 찾을 때 사용하는 모델
struct SearchingLocation {
    var locationString: String
    let locationCode: String
}

// LocationSelectionView 의 CollectionView 에 넣을 모델
struct LocationCellModel {
    var cellLocationName: String
    var cellTemperature: Int
    var cellWeatherImageInt: Int
    var cellDiurnalTemperature: [Int]
}
