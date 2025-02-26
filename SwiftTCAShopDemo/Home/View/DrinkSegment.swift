//
//  DrinkSegment.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/25.
//


import SwiftUI


struct DrinkSegment:View {
    
    var onTap: () -> Void = { }
    var segmentTitle:String
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Text(segmentTitle)
                .padding()
                .background(Color("SubColor"))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }

    }
}
