//
//  Badge.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/3/1.
//

import SwiftUI

struct Badge: View {
    let count: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
            Text(String(count))
                .font(.system(size: 16))
                .padding(5)
                .background(.sub)
                .foregroundStyle(.white)
                .clipShape(Circle())
                .alignmentGuide(.top) { $0[.bottom] }
                .alignmentGuide(.trailing) { $0[.trailing] - $0.width * 0.25 }
        }
    }
}
