//
//  KloudyIndexAccessoryCircularWidget.swift
//  kloudyWidgetExtension
//
//  Created by 이주화 on 2022/11/30.
//

import SwiftUI

struct KloudyIndexAccessoryCircularWidget: View {
    var name: String = ""
    var index: String = ""
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    Image("lock_\(name)_\(index)")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
        }
    }
}


