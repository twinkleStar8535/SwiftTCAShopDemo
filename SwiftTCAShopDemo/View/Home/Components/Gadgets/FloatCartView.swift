//
//  FloatCartView.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/3/1.
//


import SwiftUI

struct FloatCartView: View {
    var width: CGFloat? = 60
    var height: CGFloat? = 60
    var img: String = "shopping_cart"
    
    var body: some View {
        VStack {
            Image(uiImage: UIImage(named: img)!)
                .foregroundStyle(.teal, .white)
                .padding()
                .frame(maxWidth: width, maxHeight: height)
                .background(.main)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.sub, lineWidth: 4))
        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 10)
    }
}

#Preview {
    FloatCartView()
}
