//
//  KloudyLaundryIndexWidget.swift
//  kloudyWidgetExtension
//
//  Created by 이주화 on 2022/11/21.
//

import WidgetKit
import SwiftUI
import Intents

struct KloudyLaundryIndexWidget: Widget {
    let kind: String = "KloudyLaundryIndexWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: KloudyProvider()) { entry in
            KloudyLaundryIndexWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("세탁 지수 위젯입니다.")
        .supportedFamilies([.systemSmall, .accessoryCircular])
    }
}

struct KloudyLaundryIndexWidgetEntryView: View {
    var entry: KloudyProvider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        switch family {
        case .systemSmall:
            KloudyLaundrySystemSmallWidgetView(entry: entry)
        case .accessoryCircular:
            KloudyLaundryAccessoryCircularWidgetView(entry: entry)
        default:
            KloudyLaundrySystemSmallWidgetView(entry: entry)
        }
    }
}

struct KloudyLaundrySystemSmallWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            if entry.locationAuth {
                switch entry.weatherInfo.localWeather[0].weatherIndex[0].laundryIndex[0].status {
                case 0:
                    Image("laundry_1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case 1:
                    Image("laundry_2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case 2:
                    Image("laundry_3")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case 3:
                    Image("laundry_4")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                default:
                    Image("laundry_1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            } else {
                Text("앱의 위치 사용을 허용해주세요!")
            }
        }
    }
}

struct KloudyLaundryAccessoryCircularWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            if entry.locationAuth {
                switch entry.weatherInfo.localWeather[0].weatherIndex[0].laundryIndex[0].status {
                case 0:
                    Image("laundry_1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case 1:
                    Image("laundry_2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case 2:
                    Image("laundry_3")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case 3:
                    Image("laundry_4")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                default:
                    Image("laundry_1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            } else {
                Text("앱의 위치 사용을 허용해주세요!")
            }
        }
    }
}
