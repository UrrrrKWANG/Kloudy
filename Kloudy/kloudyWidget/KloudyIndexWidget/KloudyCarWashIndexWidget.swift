//
//  KloudyCarWashIndexWidget.swift
//  kloudyWidgetExtension
//
//  Created by 이주화 on 2022/11/21.
//

import WidgetKit
import SwiftUI
import Intents

struct KloudyCarWashIndexWidget: Widget {
    let kind: String = "KloudyCarWashIndexWidget"
    private let supportedFamilies:[WidgetFamily] = {
        if #available(iOSApplicationExtension 16.0, *) {
            return [.systemSmall, .accessoryCircular]
        } else {
            return [.systemSmall]
        }
    }()
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: KloudyProvider()) { entry in
            KloudyCarWashIndexWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("세차 지수 위젯입니다.")
        .supportedFamilies(supportedFamilies)
    }
}

struct KloudyCarWashIndexWidgetEntryView: View {
    var entry: KloudyProvider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        switch family {
        case .systemSmall:
            KloudyCarWashSystemSmallWidgetView(entry: entry)
        case .accessoryCircular:
            KloudyCarWashAccessoryCircularWidgetView(entry: entry)
        default:
            KloudyCarWashSystemSmallWidgetView(entry: entry)
        }
    }
}

struct KloudyCarWashSystemSmallWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            if entry.locationAuth {
                switch entry.weatherInfo.localWeather[0].weatherIndex[0].carwashIndex[0].status {
                case 0:
                    KloudyIndexWidget(name: "carwash", index: "1", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 1:
                    KloudyIndexWidget(name: "carwash", index: "2", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 2:
                    KloudyIndexWidget(name: "carwash", index: "3", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 3:
                    KloudyIndexWidget(name: "carwash", index: "4", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                default:
                    KloudyIndexWidget(name: "carwash", index: "1", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                }
            } else {
                KloudyWarningWidget()
            }
        }
    }
}

struct KloudyCarWashAccessoryCircularWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            if entry.locationAuth {
                switch entry.weatherInfo.localWeather[0].weatherIndex[0].carwashIndex[0].status {
                case 0:
                    KloudyIndexWidget(name: "carwash", index: "1", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 1:
                    KloudyIndexWidget(name: "carwash", index: "2", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 2:
                    KloudyIndexWidget(name: "carwash", index: "3", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 3:
                    KloudyIndexWidget(name: "carwash", index: "4", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                default:
                    KloudyIndexWidget(name: "carwash", index: "1", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                }
            } else {
                KloudyWarningWidget()
            }
        }
    }
}

