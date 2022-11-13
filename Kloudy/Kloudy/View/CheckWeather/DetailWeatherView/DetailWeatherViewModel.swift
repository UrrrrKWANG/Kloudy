//
//  DetailWeatherViewModel.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/07.
//

import RxSwift
import RxCocoa

struct testTodayWeatherModel {
    let hour: Int
    let status: Int
    let temperature: Double
    let precipitation: Double
}

struct testWeekWeatherData {
    let day: Int
    let status: Int
    let minTemperature: Double
    let maxTemperature: Double
}

//TODO: 테스트데이터 입니다. 차후 수정 필요
struct weatehrViewModel {
    let todayWeatherDatas = Observable.of([
        testTodayWeatherModel(hour: 0, status: 1, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 1, status: 2, temperature: 15.3, precipitation: 0.5),
        testTodayWeatherModel(hour: 2, status: 3, temperature: 12.2, precipitation: 0.5),
        testTodayWeatherModel(hour: 3, status: 4, temperature: 11.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 4, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 5, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 6, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 7, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 8, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 9, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 10, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 11, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 12, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 13, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 14, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 15, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 16, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 17, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 18, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 19, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 20, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 21, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 22, status: 2, temperature: 16.5, precipitation: 0.5),
        testTodayWeatherModel(hour: 23, status: 2, temperature: 16.5, precipitation: 0.5)
    ])
    
    let weekWeatherDatas = Observable.of([
        testWeekWeatherData(day: 0, status: 1, minTemperature: 14.4, maxTemperature: 16.7),
        testWeekWeatherData(day: 1, status: 2, minTemperature: 14.4, maxTemperature: 16.7),
        testWeekWeatherData(day: 2, status: 3, minTemperature: 14.4, maxTemperature: 16.7),
        testWeekWeatherData(day: 3, status: 4, minTemperature: 14.4, maxTemperature: 16.7),
        testWeekWeatherData(day: 4, status: 5, minTemperature: 14.4, maxTemperature: 16.7),
        testWeekWeatherData(day: 5, status: 0, minTemperature: 14.4, maxTemperature: 16.7),
        testWeekWeatherData(day: 6, status: 1, minTemperature: 14.4, maxTemperature: 16.7)
    ])
}
