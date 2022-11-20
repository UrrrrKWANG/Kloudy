//
//  KloudyOuterIndexWidget.swift
//  kloudyWidgetExtension
//
//  Created by 이주화 on 2022/11/21.
//
import WidgetKit
import SwiftUI
import Intents

struct KloudyOuterIndexWidget: Widget {
    let kind: String = "KloudyOuterIndexWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: KloudyProvider()) { entry in
            KloudyOuterIndexWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("겉옷 지수 위젯입니다.")
        .supportedFamilies([.systemSmall, .accessoryCircular])
    }
}

struct KloudyOuterIndexWidgetEntryView: View {
    var entry: KloudyProvider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        switch family {
        case .systemSmall:
            KloudyOuterSystemSmallWidgetView(entry: entry)
        case .accessoryCircular:
            KloudyOuterAccessoryCircularWidgetView(entry: entry)
        default:
            KloudyOuterSystemSmallWidgetView(entry: entry)
        }
    }
}

struct KloudyOuterSystemSmallWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            if entry.weatherInfo.localWeather[0].weatherIndex[0].outerIndex[0].status >= 12 {
                Image("outer_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if entry.weatherInfo.localWeather[0].weatherIndex[0].outerIndex[0].status >= 9 {
                Image("outer_2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if entry.weatherInfo.localWeather[0].weatherIndex[0].outerIndex[0].status >= 5 {
                Image("outer_3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if entry.weatherInfo.localWeather[0].weatherIndex[0].outerIndex[0].status >= -5 {
                Image("outer_4")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image("outer_5")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}

struct KloudyOuterAccessoryCircularWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            if entry.weatherInfo.localWeather[0].weatherIndex[0].outerIndex[0].status >= 12 {
                Image("outer_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if entry.weatherInfo.localWeather[0].weatherIndex[0].outerIndex[0].status >= 9 {
                Image("outer_2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if entry.weatherInfo.localWeather[0].weatherIndex[0].outerIndex[0].status >= 5 {
                Image("outer_3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if entry.weatherInfo.localWeather[0].weatherIndex[0].outerIndex[0].status >= -5 {
                Image("outer_4")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image("outer_5")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}
