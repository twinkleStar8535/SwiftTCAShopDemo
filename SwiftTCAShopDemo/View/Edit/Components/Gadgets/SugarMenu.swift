//
//  SugarMenu.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture


struct SugarMenu:View {
    
    @Bindable var store:StoreOf<CartEditDomain>
    @State private var selectedSugar:SugarUnit = .halfSugar

    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack{
                Menu {
                    ForEach(SugarUnit.allCases, id: \.self) { sugar in
                        Button {
                            store.send(.setDrinkSugar(sugar))
                            selectedSugar = sugar
                        } label: {
                            Text(sugar.rawValue)
                                .font(Font.custom("jf-openhuninn-2.1", size: 18))
                        }
                        
                    }
                } label: {
                    
                    HStack {
                        Text(store.cartEditItem.sugarUnit.rawValue)
                            .font(Font.custom("jf-openhuninn-2.1", size: 18))
                            .tint(.white)
                        Spacer()
                        Image(uiImage: UIImage(named: "down")!)
                    }
                    .padding()
                    .background(.sub)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                }
            }
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(.sub, lineWidth: 4))
            .padding([.top], 12)
            
            Text("甜度")
                .padding([.horizontal], 5)
                .foregroundStyle(.sub)
                .background(.main)
                .padding([.horizontal])
        }
        .padding()
    }
}


#Preview {
    SugarMenu(store: .init(initialState: CartEditDomain.State.previewState(), reducer: {
        CartEditDomain()
    }))
}
