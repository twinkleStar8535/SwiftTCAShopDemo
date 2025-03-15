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
                .font(Font.custom("jf-openhuninn-2.1", size: 18))
                .padding()
                .background(Color("SubColor"))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }

    }
}



#Preview {
    DrinkSegment(onTap: {}, segmentTitle: "Test")
}
