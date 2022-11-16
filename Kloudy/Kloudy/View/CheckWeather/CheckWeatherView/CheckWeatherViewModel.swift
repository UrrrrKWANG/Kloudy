//
//  CheckWeatherViewModel.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

struct CityWeather {
    let localName: String
    let currentWeather: Int
    let currentTemperature: Double
    
    init(localName: String, currentWeather: Int, currentTemperature: Double) {
        self.localName = localName
        self.currentWeather = currentWeather
        self.currentTemperature = currentTemperature
    }
}

struct CheckWeatherViewModel {
    let cityWeather = [
        CityWeather(localName: "포항시 남구 지곡동", currentWeather: 3, currentTemperature: 9.3),
        CityWeather(localName: "포항시 북구 장성동", currentWeather: 1, currentTemperature: 7.5),
        CityWeather(localName: "서울시 강남구", currentWeather: 2, currentTemperature: 5.1)
    ]
}
