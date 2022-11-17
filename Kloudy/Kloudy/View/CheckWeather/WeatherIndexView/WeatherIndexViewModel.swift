//
//  WeatherIndexViewModel.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/07.
//

import Foundation
import RxSwift
import RxCocoa

struct WeatherIndexViewModel {
    //TODO: 더미데이터 데이터 받아 온 이후 수정해야 합니다..
    var indexArray: [LocationIndexArray] = [
        LocationIndexArray(location: "포항시 남구 지곡동", IndexArray:  ["umbrellaIndex", "maskIndex","outerIndex","laundryIndex","carwashIndex","campareIndex"]),
        LocationIndexArray(location: "포항시 북구 장성동", IndexArray: ["maskIndex","umbrellaIndex"]),
        LocationIndexArray(location: "서울시 강남구", IndexArray:  ["umbrellaIndex", "maskIndex"]),
]
    //TODO: 더미데이터 데이터 받아 온 이후 수정해야 합니다.
    var indexDummyData: [IndexDatas] = [
        IndexDatas(localName: "포항시 남구 지곡동", cityIndexData: [  weatherIndex(umbrella_index: Umbrella_index(status: 2, precipitaion_24h: 13.3, precipitaion_1h_max: 12.2, precipitation_3h_max: 16, wind: 15.5), mask_index: Mask_index(status: 1, pm25value: 12.5, pm10value: 11.1, pollen_index: 3), outer_index: Outer_index(status: 2, day_min_temperature: 15.5, morning_temperature: 16.7), laundry_index: Laundry_index(status: 0, humidity: 11.1, day_max_temperature: 12.7, daily_weather: 4), carwash_index: Carwash_index(status: 3, daily_weather: 2, day_max_temperature: 17.7, daily_precipitation: 12.2, tomorrow_weather: 1, tomorrow_precipitation: 12.2, weather_3Am7pm: "비가 내릴지도 모름", pm10grade: 3, pollen_index: 2), campare_index: Campare_index(yesterday_max_temperature: 22.2, yesterday_min_temperature: 21.1, today_max_temperature: 14.6, today_min_temperature: 20.1))]),
        IndexDatas(localName: "포항시 북구 장성동", cityIndexData: [  weatherIndex(umbrella_index: Umbrella_index(status: 3, precipitaion_24h: 13.3, precipitaion_1h_max: 12.2, precipitation_3h_max: 16, wind: 15.5), mask_index: Mask_index(status: 3, pm25value: 12.5, pm10value: 11.1, pollen_index: 3), outer_index: Outer_index(status: 2, day_min_temperature: 15.5, morning_temperature: 16.7), laundry_index: Laundry_index(status: 0, humidity: 11.1, day_max_temperature: 12.7, daily_weather: 4), carwash_index: Carwash_index(status: 3, daily_weather: 2, day_max_temperature: 17.7, daily_precipitation: 12.2, tomorrow_weather: 1, tomorrow_precipitation: 12.2, weather_3Am7pm: "비가 내릴지도 모름", pm10grade: 3, pollen_index: 2), campare_index: Campare_index(yesterday_max_temperature: 22.2, yesterday_min_temperature: 21.1, today_max_temperature: 14.6, today_min_temperature: 20.1))]),
        IndexDatas(localName: "서울시 강남구", cityIndexData: [  weatherIndex(umbrella_index: Umbrella_index(status: 1, precipitaion_24h: 13.3, precipitaion_1h_max: 12.2, precipitation_3h_max: 16, wind: 15.5), mask_index: Mask_index(status: 2, pm25value: 12.5, pm10value: 11.1, pollen_index: 3), outer_index: Outer_index(status: 2, day_min_temperature: 15.5, morning_temperature: 16.7), laundry_index: Laundry_index(status: 0, humidity: 11.1, day_max_temperature: 12.7, daily_weather: 4), carwash_index: Carwash_index(status: 3, daily_weather: 2, day_max_temperature: 17.7, daily_precipitation: 12.2, tomorrow_weather: 1, tomorrow_precipitation: 12.2, weather_3Am7pm: "비가 내릴지도 모름", pm10grade: 3, pollen_index: 2), campare_index: Campare_index(yesterday_max_temperature: 22.2, yesterday_min_temperature: 21.1, today_max_temperature: 14.6, today_min_temperature: 20.1))]),
    ]
}

struct LocationIndexArray {
    var location: String
    var IndexArray: [String]
}

struct IndexDatas {
    var localName: String
    var cityIndexData: [weatherIndex]
}

struct weatherIndex {
    var umbrella_index: Umbrella_index
    var mask_index: Mask_index
    var outer_index: Outer_index
    var laundry_index: Laundry_index
    var carwash_index: Carwash_index
    var campare_index: Campare_index
}


struct Umbrella_index {
    var status: Int
    var precipitaion_24h: Double
    var precipitaion_1h_max: Double
    var precipitation_3h_max: Double
    var wind: Double
}

struct Mask_index {
    var status: Int
    var pm25value: Double
    var pm10value: Double
    var pollen_index: Int
}

struct Outer_index {
    var status: Int
    var day_min_temperature: Double
    var morning_temperature: Double
}
        
struct Laundry_index {
    var status: Int
    var humidity: Double
    var day_max_temperature: Double
    var daily_weather: Int
}
struct Carwash_index {
    var status: Int
    var daily_weather: Int
    var day_max_temperature: Double
    var daily_precipitation: Double
    var tomorrow_weather: Int
    var tomorrow_precipitation: Double
    var weather_3Am7pm: String
    var pm10grade: Int
    var pollen_index: Int
}
struct Campare_index {
    var yesterday_max_temperature: Double
    var yesterday_min_temperature: Double
    var today_max_temperature: Double
    var today_min_temperature: Double
}
