//
//  KloudyTodayWidget.swift
//  kloudyWidgetExtension
//
//  Created by 이주화 on 2022/10/18.
//

import WidgetKit
import SwiftUI
import Intents

struct KloudyTodayWidget: Widget {
    let kind: String = "KloudyTodayWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            KloudyTodayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("구르미 오늘 날씨 위젯 목록")
        .description("원하는 크기의 위젯을 골라주세요.")
        .supportedFamilies([.systemMedium,.systemLarge])
    }
}

struct KloudyTodayWidgetEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var entry: Provider.Entry
    
    var body: some View {
        switch family{
        case .systemSmall:
            Text(entry.date, style: .time)
        case .systemMedium:
            KloudyTodayWidgetMediumView()
        default:
            Text(entry.date, style: .time)
        }
    }
}

struct KloudyTodayWidgetMediumView: View {
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 20) {
                ForEach(0..<5) { i in
                    VStack {
                        Text("\(i + 1)시")
                            .font(.system(size: 25))
                    }
                }
            }
        }
    }
}
