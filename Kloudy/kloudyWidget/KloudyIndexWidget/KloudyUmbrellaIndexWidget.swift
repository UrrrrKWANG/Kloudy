//
//  KloudyIndexWidget.swift
//  Kloudy
//
//  Created by 이주화 on 2022/10/20.
//

import WidgetKit
import SwiftUI
import Intents

struct KloudyUmbrellaIndexWidget1: Widget {
    let kind: String = "KloudyUmbrellaIndexWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            KloudyUmbrellaIndexWidgetEntryView1(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("원하는 날씨의 위젯을 골라주세요.")
        .supportedFamilies([.systemSmall, .accessoryCircular])
    }
}

struct KloudyUmbrellaIndexWidgetEntryView1: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        switch family {
        case .systemSmall:
            KloudyUmbrellaSystemSmallWidgetView1(entry: entry)
        case .accessoryCircular:
            KloudyUmbrellaAccessoryCircularWidgetView1(entry: entry)
        default:
            KloudyUmbrellaSystemSmallWidgetView1(entry: entry)
        }
    }
}

struct KloudyUmbrellaSystemSmallWidgetView1: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Image("rain_1")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

struct KloudyUmbrellaAccessoryCircularWidgetView1: View {
    var entry: Provider.Entry
    
    var body: some View {
        Text("현재 지역의")
        Text("비 지수")
    }
}


struct KloudyUmbrellaIndexWidget2: Widget {
    let kind: String = "KloudyUmbrellaIndexWidget2"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            KloudyUmbrellaIndexWidgetEntryView2(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("원하는 날씨의 위젯을 골라주세요.")
        .supportedFamilies([.systemSmall, .accessoryCircular])
    }
}

struct KloudyUmbrellaIndexWidgetEntryView2: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        switch family {
        case .systemSmall:
            KloudyUmbrellaSystemSmallWidgetView2(entry: entry)
        case .accessoryCircular:
            KloudyUmbrellaAccessoryCircularWidgetView2(entry: entry)
        default:
            KloudyUmbrellaSystemSmallWidgetView2(entry: entry)
        }
    }
}

struct KloudyUmbrellaSystemSmallWidgetView2: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Image("rain_2")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

struct KloudyUmbrellaAccessoryCircularWidgetView2: View {
    var entry: Provider.Entry
    
    var body: some View {
        Text("현재 지역의")
        Text("비 지수")
    }
}


struct KloudyUmbrellaIndexWidget3: Widget {
    let kind: String = "KloudyUmbrellaIndexWidget3"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            KloudyUmbrellaIndexWidgetEntryView3(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("원하는 날씨의 위젯을 골라주세요.")
        .supportedFamilies([.systemSmall, .accessoryCircular])
    }
}

struct KloudyUmbrellaIndexWidgetEntryView3: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        switch family {
        case .systemSmall:
            KloudyUmbrellaSystemSmallWidgetView3(entry: entry)
        case .accessoryCircular:
            KloudyUmbrellaAccessoryCircularWidgetView3(entry: entry)
        default:
            KloudyUmbrellaSystemSmallWidgetView3(entry: entry)
        }
    }
}

struct KloudyUmbrellaSystemSmallWidgetView3: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Image("rain_3")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

struct KloudyUmbrellaAccessoryCircularWidgetView3: View {
    var entry: Provider.Entry
    
    var body: some View {
        Text("현재 지역의")
        Text("비 지수")
    }
}


struct KloudyUmbrellaIndexWidget4: Widget {
    let kind: String = "KloudyUmbrellaIndexWidget4"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            KloudyUmbrellaIndexWidgetEntryView4(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("원하는 날씨의 위젯을 골라주세요.")
        .supportedFamilies([.systemSmall, .accessoryCircular])
    }
}

struct KloudyUmbrellaIndexWidgetEntryView4: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        switch family {
        case .systemSmall:
            KloudyUmbrellaSystemSmallWidgetView4(entry: entry)
        case .accessoryCircular:
            KloudyUmbrellaAccessoryCircularWidgetView4(entry: entry)
        default:
            KloudyUmbrellaSystemSmallWidgetView4(entry: entry)
        }
    }
}

struct KloudyUmbrellaSystemSmallWidgetView4: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Image("rain_4")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

struct KloudyUmbrellaAccessoryCircularWidgetView4: View {
    var entry: Provider.Entry
    
    var body: some View {
        Text("현재 지역의")
        Text("비 지수")
    }
}
