//
//  kloudyWidget.swift
//  kloudyWidget
//
//  Created by 이영준 on 2022/10/20.
//

import WidgetKit
import SwiftUI
import Intents

struct KloudyProvider: IntentTimelineProvider {
    typealias Entry = KloudyEntry
    typealias Intent = ConfigurationIntent
    
    func placeholder(in context: Context) -> KloudyEntry {
        KloudyEntry(date: Date(), configuration: ConfigurationIntent(), weatherInfo: FetchWeatherInformation.shared.dummyData, locationAuth: true, currentCity: "종로구")
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (KloudyEntry) -> Void) {
        let entry = KloudyEntry(date: Date(), configuration: ConfigurationIntent(), weatherInfo: FetchWeatherInformation.shared.dummyData, locationAuth: true, currentCity: "종로구")
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [KloudyEntry] = []
        var weather: Weather = Weather(today: "", localWeather: [])
        let currentStatus = CLLocationManager().authorizationStatus
        if currentStatus == .authorizedAlways || currentStatus == .authorizedWhenInUse {
            LocationManager.shared.requestNowLocationInfoCity(completion: { (city) in
                guard let city = city else { return }
                let nowLocation = FetchWeatherInformation.shared.getLocationInfo(province: city[0], city: city[1])
                guard let nowLocation = nowLocation else { return }
                FetchWeatherInformation.shared.startLoad(province: nowLocation.province, city: nowLocation.city) { response in
                    weather = response
                    let currentDate = Date()
                    let entryDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
                    let entry = KloudyEntry(date: Date(), configuration: configuration, weatherInfo: response, locationAuth: true, currentCity: nowLocation.city)
                    entries.append(entry)
                    let timeline = Timeline(entries: [entry], policy: .after(entryDate))
                    completion(timeline)
                }
            })
        } else {
            let currentDate = Date()
            let entryDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
            let entry = KloudyEntry(date: Date(), configuration: configuration, weatherInfo: FetchWeatherInformation.shared.dummyData, locationAuth: false, currentCity: "종로구")
            entries.append(entry)
            let timeline = Timeline(entries: [entry], policy: .after(entryDate))
            completion(timeline)
        }
    }
}

struct KloudyEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let weatherInfo: Weather
    let locationAuth: Bool
    let currentCity: String
}

@main
struct KloudyWidget: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        KloudyUmbrellaIndexWidget()
        KloudyMaskIndexWidget()
        KloudyLaundryIndexWidget()
        KloudyCarWashIndexWidget()
        KloudyOuterIndexWidget()
        //            KloudyTodayWidget()
        //            KloudyWeeklyWidget()
    }
}
