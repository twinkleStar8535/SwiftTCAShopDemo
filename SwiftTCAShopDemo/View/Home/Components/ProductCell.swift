//
//  DrinkCell.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/21.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct DrinkCell :View {
    let drink:Drink
    
    var body: some View {
        VStack {

            KFImage(URL(string: drink.img)!)
                .onFailure { error in
                            print("Kingfisher Download Failed: \(error.localizedDescription)")
                            print("Kingfisher Error: \(error)")
                        }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 125)
                .padding(.bottom,5)
            
            Text(drink.name)
                .font(Font.custom("jf-openhuninn-2.1", size: 16))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.bottom,5)
            
            HStack {
                switch (drink.prices.mPrice, drink.prices.lPrice) {
                case (nil, nil):
                    Text("此商品尚未上市")
                        .font(Font.custom("jf-openhuninn-2.1", size: 14))
                        .foregroundStyle(.white)
                case (nil,let l?):
                    Text("L:$\(l)")
                        .font(Font.custom("jf-openhuninn-2.1", size: 14))
                        .foregroundStyle(.white)
                case (let m?, nil):
                    Text("M:$\(m)")
                        .font(Font.custom("jf-openhuninn-2.1", size: 14))
                        .foregroundStyle(.white)
                case (let m?, let l?):
                    Text("M:$\(m)  L:$\(l)")
                        .font(Font.custom("jf-openhuninn-2.1", size: 14))
                        .foregroundStyle(.white)
                }
            }

        }
        .padding(20.0)
        .background(Color("MainColor"))
    }
    
}

#Preview {
    DrinkCell(drink: DrinkCategory.sample[0].drinks[1])
}
