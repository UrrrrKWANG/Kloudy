//
//  KloudyIndexWidget.swift
//  kloudyWidgetExtension
//
//  Created by 이주화 on 2022/11/30.
//

import SwiftUI

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
                            .fontWeight(.medium)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                .padding(.top, geo.size.width * 104/170)
                .padding(.bottom, geo.size.width * 40/170)
                .padding(.leading, geo.size.width * 16/170)
                VStack {
                    HStack(spacing: 3) {
                        Text("\(city)")
                            .foregroundColor(Color("Black"))
                            .font(.system(size: geo.size.width * 14/170))
                            .fontWeight(.medium)
                        Image("locaition")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width * 12/170, height: geo.size.width * 12/170)
                        Spacer()
                    }
                }
                .padding(.top, geo.size.width * 137/170)
                .padding(.bottom, geo.size.width * 18/170)
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

