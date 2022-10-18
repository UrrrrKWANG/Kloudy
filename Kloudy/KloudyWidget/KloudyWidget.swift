//
//  KloudyWidget.swift
//  KloudyWidget
//
//  Created by 이주화 on 2022/10/17.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    typealias Entry = SimpleEntry
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct KloudyWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

@main
struct KloudyWidget: WidgetBundle {
    @WidgetBundleBuilder
        var body: some Widget {
//            KloudySimpleWidget()
            KloudyTodayWidget()
            KloudyWeeklyWidget()
            KloudyUmbrellaWidget()
            KloudyMaskWidget()
        }
}


struct KloudySimpleWidget: Widget {
    let kind: String = "KloudySimpleWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            KloudyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("구르미 간단 날씨 위젯 목록")
        .description("원하는 크기의 위젯을 골라주세요.")
        .supportedFamilies([.systemLarge])
    }
}

