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
        KloudyEntry(date: Date(), configuration: ConfigurationIntent(), weatherInfo: Weather(today: "", localWeather: []))
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (KloudyEntry) -> Void) {
        let currentStatus = CLLocationManager().authorizationStatus
        
        if currentStatus == .authorizedAlways {
            let XY = LocationManager.shared.requestNowLocationInfo()
            let nowLocation = FetchWeatherInformation.shared.getLocationInfoByXY(x: XY[0], y: XY[1])
            guard let nowLocation = nowLocation else { return }
            FetchWeatherInformation.shared.startLoad(province: nowLocation.province, city: nowLocation.city) { response in
                let entry = KloudyEntry(date: Date(), configuration: configuration, weatherInfo: response)
                completion(entry)
            }
        }
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [KloudyEntry] = []
        var weather: Weather = Weather(today: "", localWeather: [])
        let currentStatus = CLLocationManager().authorizationStatus
        
        if currentStatus == .authorizedAlways {
            let XY = LocationManager.shared.requestNowLocationInfo()
            let nowLocation = FetchWeatherInformation.shared.getLocationInfoByXY(x: XY[0], y: XY[1])
            guard let nowLocation = nowLocation else { return }
            FetchWeatherInformation.shared.startLoad(province: nowLocation.province, city: nowLocation.city) { response in
                weather = response
                let currentDate = Date()
                let entryDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
                let entry = KloudyEntry(date: Date(), configuration: configuration, weatherInfo: response)
                entries.append(entry)
                let timeline = Timeline(entries: [entry], policy: .after(entryDate))
                completion(timeline)
            }
        }
    }
}

struct KloudyEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let weatherInfo: Weather
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
