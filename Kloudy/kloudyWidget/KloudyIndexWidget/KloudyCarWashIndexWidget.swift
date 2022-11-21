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

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: KloudyProvider()) { entry in
            KloudyCarWashIndexWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("세차 지수 위젯입니다.")
        .supportedFamilies([.systemSmall, .accessoryCircular])
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
            switch entry.weatherInfo.localWeather[0].weatherIndex[0].carwashIndex[0].status {
            case 0:
                Image("carwash_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case 1:
                Image("carwash_2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case 2:
                Image("carwash_3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case 3:
                Image("carwash_4")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            default:
                Image("carwash_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}

struct KloudyCarWashAccessoryCircularWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            switch entry.weatherInfo.localWeather[0].weatherIndex[0].carwashIndex[0].status {
            case 0:
                Image("carwash_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case 1:
                Image("carwash_2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case 2:
                Image("carwash_3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case 3:
                Image("carwash_4")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            default:
                Image("carwash_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}

