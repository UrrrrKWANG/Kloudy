//
//  KloudyIndexWidget.swift
//  Kloudy
//
//  Created by 이주화 on 2022/10/20.
//

import WidgetKit
import SwiftUI
import Intents

struct KloudyUmbrellaIndexWidget: Widget {
    let kind: String = "KloudyUmbrellaIndexWidget"
    private let supportedFamilies:[WidgetFamily] = {
        if #available(iOSApplicationExtension 16.0, *) {
            return [.systemSmall, .accessoryCircular]
        } else {
            return [.systemSmall]
        }
    }()
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: KloudyProvider()) { entry in
            KloudyUmbrellaIndexWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("우산 위젯입니다..")
        .supportedFamilies(supportedFamilies)
    }
}

struct KloudyUmbrellaIndexWidgetEntryView: View {
    var entry: KloudyProvider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        switch family {
        case .systemSmall:
            KloudyUmbrellaSystemSmallWidgetView(entry: entry)
        case .accessoryCircular:
            KloudyUmbrellaAccessoryCircularWidgetView(entry: entry)
        default:
            KloudyUmbrellaSystemSmallWidgetView(entry: entry)
        }
    }
}

struct KloudyUmbrellaSystemSmallWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            if entry.locationAuth {
                switch entry.weatherInfo.localWeather[0].weatherIndex[0].umbrellaIndex[0].status {
                case 0:
                    KloudyIndexWidget(name: "rain", index: "1", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 1:
                    KloudyIndexWidget(name: "rain", index: "2", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 2:
                    KloudyIndexWidget(name: "rain", index: "3", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 3:
                    KloudyIndexWidget(name: "rain", index: "4", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 4:
                    KloudyIndexWidget(name: "rain", index: "4", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                default:
                    KloudyIndexWidget(name: "rain", index: "1", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                }
            } else {
                KloudyWarningWidget()
            }
            
        }
    }
}

struct KloudyUmbrellaAccessoryCircularWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            if entry.locationAuth {
                switch entry.weatherInfo.localWeather[0].weatherIndex[0].umbrellaIndex[0].status {
                case 0:
                    KloudyIndexAccessoryCircularWidget(name: "rain", index: "1")
                case 1:
                    KloudyIndexAccessoryCircularWidget(name: "rain", index: "2")
                case 2:
                    KloudyIndexAccessoryCircularWidget(name: "rain", index: "3")
                case 3:
                    KloudyIndexAccessoryCircularWidget(name: "rain", index: "4")
                case 4:
                    KloudyIndexAccessoryCircularWidget(name: "rain", index: "4")
                default:
                    KloudyIndexAccessoryCircularWidget(name: "rain", index: "1")
                }
            } else {
                KloudyWarningAccessoryCircularWidget()
            }
        }
    }
}
