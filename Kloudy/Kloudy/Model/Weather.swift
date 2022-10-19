//
//  Weather.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import Foundation

struct Weather {
    
    let main: Main
    let weatherIndex: WeatherIndex
    let byTime: ByTime
    let byWeek: ByWeek
    
    struct Main {
        // [0: "맑음", 3: "구름 많음", 4: "흐림"]
        let currentWeather: Int
        
        // [0: "없음", 1: "비", 2: "비/눈", 3: "눈"]
        let shortTimeWeather: Int
        
        // 현재 섭씨로 제공됨 -> 향후 필요시 화씨 변환 함수를 만들겠음.
        let currentTemperature: Double
        let dayMaxTemperature: Double
        let dayMinTemperature: Double
    }
    
    struct WeatherIndex {
        let umbrella_index: String
        let mask_index: String
    }
    
    struct ByTime {
        let currentWeather: [Int]
        let houlyPrecipitation: [Int]
        let HourlyTemperature: [Int]
    }
    
    struct ByWeek {
        
    }
}
