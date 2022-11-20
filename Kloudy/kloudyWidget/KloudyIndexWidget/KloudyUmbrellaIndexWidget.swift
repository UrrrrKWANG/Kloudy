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

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: KloudyProvider()) { entry in
            KloudyUmbrellaIndexWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("우산 위젯입니다..")
        .supportedFamilies([.systemSmall, .accessoryCircular])
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
            if entry.weatherInfo.localWeather[0].weatherIndex[0].umbrellaIndex[0].status == 0 {
                Image("rain_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if entry.weatherInfo.localWeather[0].weatherIndex[0].umbrellaIndex[0].status <= 3 {
                Image("rain_2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if entry.weatherInfo.localWeather[0].weatherIndex[0].umbrellaIndex[0].status <= 15 {
                Image("rain_3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if entry.weatherInfo.localWeather[0].weatherIndex[0].umbrellaIndex[0].status <= 30 {
                Image("rain_3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image("rain_4")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}

struct KloudyUmbrellaAccessoryCircularWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            if entry.weatherInfo.localWeather[0].weatherIndex[0].umbrellaIndex[0].status == 0 {
                Image("rain_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if entry.weatherInfo.localWeather[0].weatherIndex[0].umbrellaIndex[0].status <= 3 {
                Image("rain_2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if entry.weatherInfo.localWeather[0].weatherIndex[0].umbrellaIndex[0].status <= 15 {
                Image("rain_3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if entry.weatherInfo.localWeather[0].weatherIndex[0].umbrellaIndex[0].status <= 30 {
                Image("rain_3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image("rain_4")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}
