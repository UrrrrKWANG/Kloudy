//
//  KloudyCarWashIndexWidget.swift
//  kloudyWidgetExtension
//
//  Created by 이주화 on 2022/11/21.
//

import WidgetKit
import SwiftUI
import Intents

struct KloudyCarWashIndexWidget: Widget {
    let kind: String = "KloudyCarWashIndexWidget"
    private let supportedFamilies:[WidgetFamily] = {
        if #available(iOSApplicationExtension 16.0, *) {
            return [.systemSmall, .accessoryCircular]
        } else {
            return [.systemSmall]
        }
    }()
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: KloudyProvider()) { entry in
            KloudyCarWashIndexWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("세차 지수 위젯입니다.")
        .supportedFamilies(supportedFamilies)
    }
}

struct KloudyCarWashIndexWidgetEntryView: View {
    var entry: KloudyProvider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        switch family {
        case .systemSmall:
            KloudyCarWashSystemSmallWidgetView(entry: entry)
        case .accessoryCircular:
            KloudyCarWashAccessoryCircularWidgetView(entry: entry)
        default:
            KloudyCarWashSystemSmallWidgetView(entry: entry)
        }
    }
}

struct KloudyCarWashSystemSmallWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            if entry.locationAuth {
                switch entry.weatherInfo.localWeather[0].weatherIndex[0].carwashIndex[0].status {
                case 0:
                    Image("carwash_1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case 1:
                    Image("carwash_2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case 2:
                    Image("carwash_3")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case 3:
                    Image("carwash_4")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                default:
                    Image("carwash_1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            } else {
                Text("앱의 위치 사용을 허용해주세요!")
            }
        }
    }
}

struct KloudyCarWashAccessoryCircularWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            if entry.locationAuth {
                switch entry.weatherInfo.localWeather[0].weatherIndex[0].carwashIndex[0].status {
                case 0:
                    Image("carwash_1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case 1:
                    Image("carwash_2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case 2:
                    Image("carwash_3")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case 3:
                    Image("carwash_4")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                default:
                    Image("carwash_1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            } else {
                Text("앱의 위치 사용을 허용해주세요!")
            }
        }
    }
}

