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

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: KloudyProvider()) { entry in
            KloudyMaskIndexWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("마스크 위젯입니다.")
        .supportedFamilies([.systemSmall, .accessoryCircular])
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
            switch entry.weatherInfo.localWeather[0].weatherIndex[0].maskIndex[0].status {
            case 0:
                Image("mask_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case 1:
                Image("mask_2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case 2:
                Image("mask_3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case 3:
                Image("mask_4")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            default:
                Image("mask_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}

struct KloudyMaskAccessoryCircularWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            switch entry.weatherInfo.localWeather[0].weatherIndex[0].maskIndex[0].status {
            case 0:
                Image("mask_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case 1:
                Image("mask_2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case 2:
                Image("mask_3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case 3:
                Image("mask_4")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            default:
                Image("mask_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}
