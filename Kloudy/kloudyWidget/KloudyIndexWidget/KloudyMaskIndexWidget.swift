//
//  KloudyMaskIndexWidget.swift
//  kloudyWidgetExtension
//
//  Created by 이주화 on 2022/10/20.
//

import WidgetKit
import SwiftUI
import Intents

struct KloudyMaskIndexWidget1: Widget {
    let kind: String = "KloudyMaskIndexWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            KloudyMaskIndexWidgetEntryView1(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("원하는 날씨의 위젯을 골라주세요.")
        .supportedFamilies([.systemSmall, .accessoryCircular])
    }
}

struct KloudyMaskIndexWidgetEntryView1: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        switch family {
        case .systemSmall:
            KloudyMaskSystemSmallWidgetView1(entry: entry)
        case .accessoryCircular:
            KloudyMaskAccessoryCircularWidgetView1(entry: entry)
        default:
            KloudyMaskSystemSmallWidgetView1(entry: entry)
        }
    }
}

struct KloudyMaskSystemSmallWidgetView1: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Image("laundry_1")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

struct KloudyMaskAccessoryCircularWidgetView1: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Image("laundry_1")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

struct KloudyMaskIndexWidget2: Widget {
    let kind: String = "KloudyMaskIndexWidget2"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            KloudyMaskIndexWidgetEntryView2(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("원하는 날씨의 위젯을 골라주세요.")
        .supportedFamilies([.systemSmall, .accessoryCircular])
    }
}

struct KloudyMaskIndexWidgetEntryView2: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        switch family {
        case .systemSmall:
            KloudyMaskSystemSmallWidgetView2(entry: entry)
        case .accessoryCircular:
            KloudyMaskAccessoryCircularWidgetView2(entry: entry)
        default:
            KloudyMaskSystemSmallWidgetView2(entry: entry)
        }
    }
}

struct KloudyMaskSystemSmallWidgetView2: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Image("laundry_2")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

struct KloudyMaskAccessoryCircularWidgetView2: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Image("laundry_2")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

struct KloudyMaskIndexWidget3: Widget {
    let kind: String = "KloudyMaskIndexWidget3"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            KloudyMaskIndexWidgetEntryView3(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("원하는 날씨의 위젯을 골라주세요.")
        .supportedFamilies([.systemSmall, .accessoryCircular])
    }
}

struct KloudyMaskIndexWidgetEntryView3: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        switch family {
        case .systemSmall:
            KloudyMaskSystemSmallWidgetView3(entry: entry)
        case .accessoryCircular:
            KloudyMaskAccessoryCircularWidgetView3(entry: entry)
        default:
            KloudyMaskSystemSmallWidgetView3(entry: entry)
        }
    }
}

struct KloudyMaskSystemSmallWidgetView3: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Image("laundry_3")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

struct KloudyMaskAccessoryCircularWidgetView3: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Image("laundry_3")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

struct KloudyMaskIndexWidget4: Widget {
    let kind: String = "KloudyMaskIndexWidget4"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            KloudyMaskIndexWidgetEntryView4(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("원하는 날씨의 위젯을 골라주세요.")
        .supportedFamilies([.systemSmall, .accessoryCircular])
    }
}

struct KloudyMaskIndexWidgetEntryView4: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        switch family {
        case .systemSmall:
            KloudyMaskSystemSmallWidgetView4(entry: entry)
        case .accessoryCircular:
            KloudyMaskAccessoryCircularWidgetView4(entry: entry)
        default:
            KloudyMaskSystemSmallWidgetView4(entry: entry)
        }
    }
}

struct KloudyMaskSystemSmallWidgetView4: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Image("laundry_4")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

struct KloudyMaskAccessoryCircularWidgetView4: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Image("laundry_4")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}
