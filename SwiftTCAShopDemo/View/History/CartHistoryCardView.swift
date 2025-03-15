//
//  CartHistoryCardView.swift
//  SwiftTCAShopDemo
//
//  Created by iOS-林祐辰 金融研發一部 on 2025/3/6.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher


struct CartHistoryCardView: View {
    let item: CartItem
    
    var body: some View {
        HStack(spacing:50){
            VStack(alignment: .leading, spacing: 12) {
                Text("購買人: \(item.userName)")
                    .font(Font.custom("jf-openhuninn-2.1", size: 18))
                    .foregroundStyle(.white.opacity(0.8))
                
                Text(item.drinkName)
                    .font(Font.custom("jf-openhuninn-2.1", size: 16))
                    .foregroundStyle(.white)
                
                
                Text("甜度: \(item.sugarUnit.rawValue), 溫度: \(item.tempUnit.rawValue)")
                    .font(Font.custom("jf-openhuninn-2.1", size: 14))
                    .foregroundStyle(.white.opacity(0.8))
                
                
                HStack {
                    
                    Text("\(item.quantity)杯")
                        .font(Font.custom("jf-openhuninn-2.1", size: 18))
                        .foregroundStyle(.white)
                        .frame(minWidth: 30)
                        .multilineTextAlignment(.center)
                    
                    Text("小計: NT$ \(item.price)")
                        .font(Font.custom("jf-openhuninn-2.1", size: 16))
                        .foregroundStyle(.white)
                        .bold()
                }
                
            }
            
            KFImage(URL(string: item.drinkImage))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 110)
                .padding(8)
            
                .padding()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
        }
        .padding()
        .cornerRadius(10.0)
        .background(.main)
       
    }
}


#Preview {
    CartHistoryCardView(item:
                            CartItem(id: UUID(), drinkImage: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/輕纖蕎麥拿鐵.png",
                                       drinkName: "輕纖蕎麥拿鐵",
                                       userName: "DEF", size: .L, sugarUnit: .halfSugar,
                                       tempUnit: .lessIce,price: 0, quantity: 1))
}
