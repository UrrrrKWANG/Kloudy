//
//  kloudyWidget.swift
//  kloudyWidget
//
//  Created by 이영준 on 2022/10/20.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    typealias Entry = SimpleEntry
    typealias Intent = ConfigurationIntent
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
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

@main
struct KloudyWidget: WidgetBundle {
    @WidgetBundleBuilder
        var body: some Widget {
            KloudyUmbrellaIndexWidget1()
            KloudyUmbrellaIndexWidget2()
            KloudyUmbrellaIndexWidget3()
            KloudyUmbrellaIndexWidget4()
            KloudyMaskIndexWidget1()
            KloudyMaskIndexWidget2()
            KloudyMaskIndexWidget3()
            KloudyMaskIndexWidget4()
//            KloudyTodayWidget()
//            KloudyWeeklyWidget()
        }
}
