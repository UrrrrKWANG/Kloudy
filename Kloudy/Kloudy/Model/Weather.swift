//
//  Weather.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import Foundation

struct Weather: Codable {
    let today: String
    let localWeather: [LocalWeather]
    
    enum CodingKeys: String, CodingKey {
        case today
        case localWeather = "local_weather"
    }
}

struct LocalWeather: Codable {
    let localCode: String
    let localName: String
    let main: [Main]
    let weatherIndex: [WeatherIndex]
    let weeklyWeather: [WeeklyWeather]
    let hourlyWeather: [HourlyWeather]
    
    enum CodingKeys: String, CodingKey {
        case localCode = "local_code"
        case localName = "local_name"
        case main
        case weatherIndex = "weather_index"
        case weeklyWeather = "weekly_weather"
        case hourlyWeather = "hourly_weather"
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
    let umbrellaIndex: [UmbrellaIndex]
    let maskIndex: [MaskIndex]
    let outerIndex: [OuterIndex]
    let laundryIndex: [LaundryIndex]
    let carwashIndex: [CarwashIndex]
    let compareIndex: [CompareIndex]
    
    enum CodingKeys: String, CodingKey {
        case maskIndex = "mask_index"
        case outerIndex = "outer_index"
        case laundryIndex = "laundry_index"
        case carwashIndex = "carwash_index"
        case compareIndex = "compare_index"
        case umbrellaIndex = "umbrella_index"
    }
}

struct UmbrellaIndex: Codable {
    let status: Int
    let precipitation24H: Double
    let precipitation1hMax: Double
    let precipitation3hMax: Double
    let wind: Double
    let umbrellaHourly: [UmbrellaHourly]
    
    enum CodingKeys: String, CodingKey {
        case status, wind
        case precipitation24H = "precipitation_24h"
        case precipitation1hMax = "precipitation_1h_max"
        case precipitation3hMax = "precipitation_3h_max"
        case umbrellaHourly = "umbrella_hourly"
    }
}

struct UmbrellaHourly: Codable {
    let time: Int
    let precipitation: Double
    
    enum CodingKeys: String, CodingKey {
        case time, precipitation
    }
}

struct MaskIndex: Codable {
    let status: Int
    let pollenIndex: Int
    let todayPM25value: Double
    let todayPM10value: Double
    let yesterdayPM25value: Double
    let yesterdayPM10value: Double
    let yesterday: String
    let today: String
    
    enum CodingKeys: String, CodingKey {
        case status, yesterday, today
        case pollenIndex = "pollen_index"
        case todayPM25value = "today_pm25value"
        case todayPM10value = "today_pm10value"
        case yesterdayPM25value = "yesterday_pm25value"
        case yesterdayPM10value = "yesterday_pm10value"
    }
}

struct OuterIndex: Codable {
    let status: Int
    let dayMinTemperature: Double
    let morningTemperature: Double
    
    enum CodingKeys: String, CodingKey {
        case status
        case dayMinTemperature = "day_min_temperature"
        case morningTemperature = "morning_temperature"
    }
}

struct LaundryIndex: Codable {
    let status: Int
    let humidity: Double
    let dayMaxTemperature: Double
    let dailyWeather: Int
    let humidityHourly: [HumidityHourly]
    
    enum CodingKeys: String, CodingKey {
        case status, humidity
        case dayMaxTemperature = "day_max_temperature"
        case dailyWeather = "daily_weather"
        case humidityHourly = "humidity_hourly"
    }
}

struct HumidityHourly: Codable {
    let time: Int
    let humidity: Double
    
    enum CodingKeys: String, CodingKey {
        case time, humidity
    }
}

struct WeeklyWeather: Codable {
    let day: Int
    let status: Int
    let maxTemperature: Double
    let minTemperature: Double
    
    enum CodingKeys: String, CodingKey {
        case day, status
        case maxTemperature = "max_temperature"
        case minTemperature = "min_temperature"
    }
}

struct CarwashIndex: Codable {
    let status: Int
    let dailyWeather: Int
    let dayMaxTemperature: Double
    let dailyPrecipitation: Double
    let tomorrowWeather: Int
    let tomorrowPrecipication: Double
    let weather3Am7pm: String
    let pm10grade: Int
    let pollenIndex: Int
    let precipitationDaily: [PrecipitationDaily]

    enum CodingKeys: String, CodingKey {
        case status, pm10grade
        case dailyWeather = "daily_weather"
        case dayMaxTemperature = "day_max_temperature"
        case dailyPrecipitation = "daily_precipitation"
        case tomorrowWeather = "tomorrow_weather"
        case tomorrowPrecipication = "tomorrow_precipitation"
        case weather3Am7pm = "weather_3Am7pm"
        case pollenIndex = "pollen_index"
        case precipitationDaily = "precipitation_daily"
    }
}

struct PrecipitationDaily: Codable {
    let day: Int
    let precipitation: Double
    
    enum CodingKeys: String, CodingKey {
        case day, precipitation
    }
}

struct CompareIndex: Codable {
    let yesterdayMaxTemperature: Double
    let yesterdayMinTemperature: Double
    let todayMaxtemperature: Double
    let todayMinTemperature: Double
    
    enum CodingKeys: String, CodingKey {
        case yesterdayMaxTemperature = "yesterday_max_temperature"
        case yesterdayMinTemperature = "yesterday_min_temperature"
        case todayMaxtemperature = "today_max_temperature"
        case todayMinTemperature = "today_min_temperature"
    }
}

struct HourlyWeather: Codable {
    let hour: Int
    let status: Int
    let temperature: Double
    let precipitation: Double
}
