//
//  Weather.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import Foundation

struct Weather: Codable {
    let today: String
    let main: [Main]
    let weatherIndex: [WeatherIndex]
    
    enum CodingKeys: String, CodingKey {
        case today, main
        case weatherIndex = "weather_index"
    }
}

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

struct WeatherIndex: Codable {
    let umbrellaIndex: Double
    let maskIndex: [MaskIndex]
    
    enum CodingKeys: String, CodingKey {
        case umbrellaIndex = "umbrella_index"
        case maskIndex = "mask_index"
    }
}

struct MaskIndex: Codable {
    // (0~15 : 좋음 | 16~35 : 보통 | 36~75 : 나쁨 | 76 : 매우나쁨) 으로 사용하면 됩니다.
    let airQuality: Int
    
    // 0이면 없음 1이면 있음
    let flowerQuality: Int
    let dustQuality: Int
    
    enum CodingKeys: String, CodingKey {
        case airQuality = "air_quality"
        case flowerQuality = "flower_quality"
        case dustQuality = "dust_quality"
    }
}
