//
//  KloudyWarningAccessoryCircularWidget.swift
//  kloudyWidgetExtension
//
//  Created by 이주화 on 2022/11/30.
//

import SwiftUI

struct KloudyWarningAccessoryCircularWidget: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black
                VStack {
                    HStack {
                        Spacer()
                        Image("lockWarning")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width * 9/55, height: geo.size.width * 9/55)
                            .padding(.top, geo.size.width * 8/55)
                        Spacer()
                    }
                    Spacer()
                }
                VStack {
                    Text("날씨앱 사용...")
                        .foregroundColor(Color.white)
                        .font(.system(size: geo.size.width * 8/55))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}
