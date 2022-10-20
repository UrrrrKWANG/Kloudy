//
//  KloudyIndexWidget.swift
//  Kloudy
//
//  Created by 이주화 on 2022/10/20.
//

import WidgetKit
import SwiftUI
import Intents

struct KloudyUmbrellaIndexWidget: Widget {
    let kind: String = "KloudyUmbrellaIndexWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            KloudyUmbrellaIndexWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("원하는 날씨의 위젯을 골라주세요.")
        .supportedFamilies([.systemSmall])
    }
}

struct KloudyUmbrellaIndexWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        Text("\(String(entry.configuration.WidgetLocaion ?? ""))시의 ")
        Text("비 지수")
    }
}
