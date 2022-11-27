//
//  LocalWeather+.swift
//  Kloudy
//
//  Created by Hyeongjung on 2022/11/22.
//

import Foundation

extension LocalWeather {
    func minMaxTemperature() -> [Int] {
        let currentTemperature: Int = Int(self.hourlyWeather[2].temperature)
        var dayMaxTemperatureArray: [Int] = []
        var dayMinTemperatureArray: [Int] = []
        let count: Int = 26 - (Int(Date().getTimeOfDay()) ?? 0) > 24 ? 24 : 26 - (Int(Date().getTimeOfDay()) ?? 0)
        
        dayMaxTemperatureArray.append(Int(self.weeklyWeather[0].maxTemperature))
        dayMaxTemperatureArray.append(currentTemperature)
        dayMinTemperatureArray.append(Int(self.weeklyWeather[0].minTemperature))
        dayMinTemperatureArray.append(currentTemperature)
        
        (0..<count).forEach {
            dayMaxTemperatureArray.append(Int(self.hourlyWeather[$0].temperature))
            dayMinTemperatureArray.append(Int(self.hourlyWeather[$0].temperature))
        }
        let dayMaxTemperature: Int = dayMaxTemperatureArray.max() ?? 0
        let dayMinTemperature: Int = dayMinTemperatureArray.min() ?? 0
        
        return [currentTemperature, dayMaxTemperature, dayMinTemperature]
    }
}


