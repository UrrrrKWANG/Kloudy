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
        KloudyEntry(date: Date(), configuration: ConfigurationIntent(), weatherInfo: FetchWeatherInformation.shared.dummyData, locationAuth: true)
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (KloudyEntry) -> Void) {
        let entry = KloudyEntry(date: Date(), configuration: ConfigurationIntent(), weatherInfo: FetchWeatherInformation.shared.dummyData, locationAuth: true)
        completion(entry)
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
                let entry = KloudyEntry(date: Date(), configuration: configuration, weatherInfo: response, locationAuth: true)
                entries.append(entry)
                let timeline = Timeline(entries: [entry], policy: .after(entryDate))
                completion(timeline)
            }
        } else {
            let currentDate = Date()
            let entryDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
            let entry = KloudyEntry(date: Date(), configuration: configuration, weatherInfo: FetchWeatherInformation.shared.dummyData, locationAuth: false)
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
