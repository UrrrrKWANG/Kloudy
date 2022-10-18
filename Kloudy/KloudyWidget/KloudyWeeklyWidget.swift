//
//  KloudyWeeklyWidget.swift
//  kloudyWidgetExtension
//
//  Created by 이주화 on 2022/10/18.
//

import WidgetKit
import SwiftUI
import Intents

struct KloudyWeeklyWidget: Widget {
    let kind: String = "KloudyWeeklyWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            KloudyWeeklyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("구르미 주간 날씨 위젯 목록")
        .description("원하는 크기의 위젯을 골라주세요.")
        .supportedFamilies([.systemMedium,.systemLarge])
    }
}

struct KloudyWeeklyWidgetEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var entry: Provider.Entry
    
    var body: some View {
        switch family{
        case .systemSmall:
            Text(entry.date, style: .time)
        case .systemMedium:
            KloudyWeeklyWidgetMediumView()
        default:
            Text(entry.date, style: .time)
        }
    }
}

struct KloudyWeeklyWidgetMediumView: View {
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 20) {
                ForEach(0..<5) { i in
                    VStack {
                        Text("\(i + 1)일의 날씨")
                            .font(.system(size: 16))
                    }
                }
            }
        }
    }
}
