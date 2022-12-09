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
