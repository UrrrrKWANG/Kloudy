//
//  LocalWeather+.swift
//  Kloudy
//
//  Created by Hyeongjung on 2022/11/22.
//

import Foundation

extension LocalWeather {
    func minMaxTemperature() -> [Int] {
        var currentTemperature: Int = Int(self.main[0].currentTemperature)
        var dayMaxTemperature: Int = Int(self.main[0].dayMaxTemperature)
        var dayMinTemperature: Int = Int(self.main[0].dayMinTemperature)
        
        if currentTemperature > dayMaxTemperature {
            dayMaxTemperature = currentTemperature
        }
        if currentTemperature < dayMinTemperature {
            dayMinTemperature = currentTemperature
        }
        return [currentTemperature, dayMaxTemperature, dayMinTemperature]
    }
}


