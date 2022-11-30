//
//  KloudyMaskIndexWidget.swift
//  kloudyWidgetExtension
//
//  Created by 이주화 on 2022/10/20.
//

import WidgetKit
import SwiftUI
import Intents

struct KloudyMaskIndexWidget: Widget {
    let kind: String = "KloudyMaskIndexWidget"
    private let supportedFamilies:[WidgetFamily] = {
        if #available(iOSApplicationExtension 16.0, *) {
            return [.systemSmall, .accessoryCircular]
        } else {
            return [.systemSmall]
        }
    }()
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: KloudyProvider()) { entry in
            KloudyMaskIndexWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("마스크 위젯입니다.")
        .supportedFamilies(supportedFamilies)
    }
}

struct KloudyMaskIndexWidgetEntryView: View {
    var entry: KloudyProvider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        switch family {
        case .systemSmall:
            KloudyMaskSystemSmallWidgetView(entry: entry)
        case .accessoryCircular:
            KloudyMaskAccessoryCircularWidgetView(entry: entry)
        default:
            KloudyMaskSystemSmallWidgetView(entry: entry)
        }
    }
}

struct KloudyMaskSystemSmallWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            if entry.locationAuth {
                switch entry.weatherInfo.localWeather[0].weatherIndex[0].maskIndex[0].status {
                case 0:
                    KloudyIndexWidget(name: "mask", index: "1", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 1:
                    KloudyIndexWidget(name: "mask", index: "2", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 2:
                    KloudyIndexWidget(name: "mask", index: "3", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 3:
                    KloudyIndexWidget(name: "mask", index: "4", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                default:
                    KloudyIndexWidget(name: "mask", index: "1", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                }
            } else {
                KloudyWarningWidget()
            }
        }
    }
}

struct KloudyMaskAccessoryCircularWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            if entry.locationAuth {
                switch entry.weatherInfo.localWeather[0].weatherIndex[0].maskIndex[0].status {
                case 0:
                    KloudyIndexWidget(name: "mask", index: "1", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 1:
                    KloudyIndexWidget(name: "mask", index: "2", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 2:
                    KloudyIndexWidget(name: "mask", index: "3", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 3:
                    KloudyIndexWidget(name: "mask", index: "4", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                default:
                    KloudyIndexWidget(name: "mask", index: "1", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                }
            } else {
                KloudyWarningWidget()
            }
        }
    }
}
