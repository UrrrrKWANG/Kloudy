//
//  KloudyWarningWidget.swift
//  Kloudy
//
//  Created by 이주화 on 2022/11/29.
//

import SwiftUI

struct KloudyWarningWidget: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color("PrimaryBlue07")
                VStack {
                    HStack {
                        Image("warning")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width * 32/170, height: geo.size.width * 32/170)
                            .padding([.leading, .top], geo.size.width * 16/170)
                        Spacer()
                    }
                    Spacer()
                }
                VStack {
                    Text("앱의 위치 사용을 항상 허용으로 변경해 주세요")
                        .foregroundColor(Color("Black"))
                        .font(.system(size: geo.size.width * 12/170))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }.frame(width: geo.size.width * 117/170)
            }
        }
    }
}

