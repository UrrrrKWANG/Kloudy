//
//  CityWeatherAPI.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/17.
//

import Foundation

struct CityWeatherAPI {
    func requestCityWeather(code: String) -> URLComponents {
        var components = URLComponents(string: "http://3.35.230.34:8080/apis/weather/?")
        components?.queryItems = [
            URLQueryItem(name: "code", value: code)
        ]
        return components ?? URLComponents()
    }
}
