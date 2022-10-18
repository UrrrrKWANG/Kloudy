//
//  KloudyMaskWidget.swift
//  kloudyWidgetExtension
//
//  Created by 이주화 on 2022/10/18.
//

import WidgetKit
import SwiftUI
import Intents

struct KloudyMaskWidget: Widget {
    let kind: String = "KloudyMaskWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            KloudyMaskWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("구르미 간단 날씨 위젯 목록")
        .description("원하는 지수를 골라주세요.")
        .supportedFamilies([.systemSmall])
    }
}

struct KloudyMaskWidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack{
            Text("오늘의 마스크 지수는?!!")
        }
    }
}

