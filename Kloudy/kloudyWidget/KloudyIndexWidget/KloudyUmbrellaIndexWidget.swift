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
    private let supportedFamilies:[WidgetFamily] = {
        if #available(iOSApplicationExtension 16.0, *) {
            return [.systemSmall, .accessoryCircular]
        } else {
            return [.systemSmall]
        }
    }()
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: KloudyProvider()) { entry in
            KloudyUmbrellaIndexWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("구르미 날씨 지수 위젯 목록")
        .description("우산 위젯입니다..")
        .supportedFamilies(supportedFamilies)
    }
}

struct KloudyUmbrellaIndexWidgetEntryView: View {
    var entry: KloudyProvider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        switch family {
        case .systemSmall:
            KloudyUmbrellaSystemSmallWidgetView(entry: entry)
        case .accessoryCircular:
            KloudyUmbrellaAccessoryCircularWidgetView(entry: entry)
        default:
            KloudyUmbrellaSystemSmallWidgetView(entry: entry)
        }
    }
}

struct KloudyUmbrellaSystemSmallWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            if entry.locationAuth {
                switch entry.weatherInfo.localWeather[0].weatherIndex[0].umbrellaIndex[0].status {
                case 0:
                    KloudyIndexWidget(name: "rain", index: "1", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 1:
                    KloudyIndexWidget(name: "rain", index: "2", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 2:
                    KloudyIndexWidget(name: "rain", index: "3", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 3:
                    KloudyIndexWidget(name: "rain", index: "4", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 4:
                    KloudyIndexWidget(name: "rain", index: "4", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                default:
                    KloudyIndexWidget(name: "rain", index: "1", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                }
            } else {
                KloudyWarningWidget()
            }
            
        }
    }
}

struct KloudyUmbrellaAccessoryCircularWidgetView: View {
    var entry: KloudyProvider.Entry
    
    var body: some View {
        VStack {
            if entry.locationAuth {
                switch entry.weatherInfo.localWeather[0].weatherIndex[0].umbrellaIndex[0].status {
                case 0:
                    KloudyIndexWidget(name: "rain", index: "1", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 1:
                    KloudyIndexWidget(name: "rain", index: "2", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 2:
                    KloudyIndexWidget(name: "rain", index: "3", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 3:
                    KloudyIndexWidget(name: "rain", index: "4", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                case 4:
                    KloudyIndexWidget(name: "rain", index: "4", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                default:
                    KloudyIndexWidget(name: "rain", index: "1", temperature: Int(entry.weatherInfo.localWeather[0].main[0].currentTemperature), city: entry.currentCity)
                }
            } else {
                KloudyWarningWidget()
            }
        }
    }
}

struct KloudyIndexWidget: View {
    var name: String = ""
    var index: String = ""
    var temperature: Int = 0
    var city: String = ""
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color("PrimaryBlue07")
                VStack {
                    HStack {
                        Spacer()
                        Image("\(name)_\(index)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width * 11/17, height: geo.size.width * 11/17)
                            .padding([.trailing, .top], geo.size.width * 16/170)
                    }
                    Spacer()
                }
                VStack {
                    HStack {
                        Text("\(String(temperature))°")
                            .foregroundColor(Color("Black"))
                            .font(.system(size: geo.size.width * 34/170))
                            .fontWeight(.regular)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                .padding(.top, geo.size.width * 90/170)
                .padding([.leading, .bottom], geo.size.width * 16/170)
                VStack {
                    HStack {
                        Text("\(city)")
                            .foregroundColor(Color("Black"))
                            .font(.system(size: geo.size.width * 14/170))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        Image("locaition")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width * 12/170, height: geo.size.width * 12/170)
                        Spacer()
                    }
                }
                .padding(.top, geo.size.width * 140/170)
                .padding(.bottom, geo.size.width * 19/170)
                .padding(.leading, geo.size.width * 16/170)
                VStack {
                    HStack {
                        Image("\(name)_index")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width * 32/170, height: geo.size.width * 32/170)
                            .padding([.leading, .top], geo.size.width * 16/170)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
}
