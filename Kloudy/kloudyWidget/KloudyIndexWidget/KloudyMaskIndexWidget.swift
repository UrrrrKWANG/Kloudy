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
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            KloudyMaskIndexWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("원하는 날씨의 위젯을 골라주세요.")
        .supportedFamilies([.systemSmall, .accessoryCircular])
    }
}

struct KloudyMaskIndexWidgetEntryView: View {
    var entry: Provider.Entry
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
    var entry: Provider.Entry
    
    var body: some View {
        Text("\(String(entry.configuration.WidgetLocaion ?? ""))시의 ")
        Text("마스크 지수")
    }
}

struct KloudyMaskAccessoryCircularWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        Text("현재 지역의")
        Text("마스크 지수")
    }
}

