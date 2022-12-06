//
//  LocalWeather+.swift
//  Kloudy
//
//  Created by Hyeongjung on 2022/11/22.
//

import Foundation

extension LocalWeather {
    func minMaxTemperature() -> [Int] {
        let currentTemperature: Int = Int(self.main[0].currentTemperature)
        let dayMaxTemperature: Int = Int(self.main[0].dayMaxTemperature)
        let dayMinTemperature: Int = Int(self.main[0].dayMinTemperature)
        
        return [currentTemperature, dayMaxTemperature, dayMinTemperature]
    }
}


