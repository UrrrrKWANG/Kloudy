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
