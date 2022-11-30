//
//  KloudyLaundryIndexWidget.swift
//  kloudyWidgetExtension
//
//  Created by 이주화 on 2022/11/21.
//

import WidgetKit
import SwiftUI
import Intents

struct KloudyLaundryIndexWidget: Widget {
    let kind: String = "KloudyLaundryIndexWidget"
    private let supportedFamilies:[WidgetFamily] = {
        if #available(iOSApplicationExtension 16.0, *) {
            return [.systemSmall, .accessoryCircular]
        } else {
            return [.systemSmall]
        }
    }()
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: KloudyProvider()) { entry in
            KloudyLaundryIndexWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("세탁 지수 위젯입니다.")
        .supportedFamilies(supportedFamilies)
    }
}

struct KloudyLaundryIndexWidgetEntryView: View {
    var entry: KloudyProvider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        switch family {
        case .systemSmall:
            KloudyLaundrySystemSmallWidgetView(entry: entry)
        case .accessoryCircular:
            KloudyLaundryAccessoryCircularWidgetView(entry: entry)
        default:
            KloudyLaundrySystemSmallWidgetView(entry: entry)
        }
    }
}

struct KloudyLaundrySystemSmallWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            if entry.locationAuth {
                switch entry.weatherInfo.localWeather[0].weatherIndex[0].laundryIndex[0].status {
                case 0:
                    KloudyIndexWidget(name: "laundry", index: "1", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 1:
                    KloudyIndexWidget(name: "laundry", index: "2", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 2:
                    KloudyIndexWidget(name: "laundry", index: "3", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 3:
                    KloudyIndexWidget(name: "laundry", index: "4", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                default:
                    KloudyIndexWidget(name: "laundry", index: "1", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                }
            } else {
                KloudyWarningWidget()
            }
        }
    }
}

struct KloudyLaundryAccessoryCircularWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            if entry.locationAuth {
                switch entry.weatherInfo.localWeather[0].weatherIndex[0].laundryIndex[0].status {
                case 0:
                    KloudyIndexAccessoryCircularWidget(name: "laundry", index: "1")
                case 1:
                    KloudyIndexAccessoryCircularWidget(name: "laundry", index: "2")
                case 2:
                    KloudyIndexAccessoryCircularWidget(name: "laundry", index: "3")
                case 3:
                    KloudyIndexAccessoryCircularWidget(name: "laundry", index: "4")
                default:
                    KloudyIndexAccessoryCircularWidget(name: "laundry", index: "1")
                }
            } else {
                KloudyWarningAccessoryCircularWidget()
            }
        }
    }
}
