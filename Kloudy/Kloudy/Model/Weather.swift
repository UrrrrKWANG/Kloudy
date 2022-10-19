//
//  Weather.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import Foundation

struct Weather: Codable {
    
    let main: Main
//    let weatherIndex: WeatherIndex
//    let byTime: ByTime
//    let byWeek: ByWeek
    
    struct Main: Codable {
        // [0: "맑음", 1: "비", 2: "비/눈, 3: "구름 많음", 4: "흐림", 5: "눈"]
        let currentWeather: Int

        // 현재 섭씨로 제공됨 -> 향후 필요시 화씨 변환 함수를 만들겠음.
        let currentTemperature: Double
        let dayMaxTemperature: Double
        let dayMinTemperature: Double
        
        enum CodingKeys: String, CodingKey {
            case currentWeather = "current_weather"
            case currentTemperature = "current_temperature"
            case dayMaxTemperature = "day_max_temperature"
            case dayMinTemperature = "day_min_temperature"
        }
    }
    
//    struct WeatherIndex {
//        let umbrellaIndex: String
//        let maskIndex: String
//    }
//
//    struct ByTime {
//        let currentWeather: [Int]
//        let houlyPrecipitation: [Int]
//        let HourlyTemperature: [Int]
//    }
//
//    struct ByWeek {
//
//    }
}
