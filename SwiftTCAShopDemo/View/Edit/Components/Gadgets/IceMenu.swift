//
//  IceMenu.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture


struct IceMenu:View {
    
    @Bindable var store:StoreOf<CartEditDomain>
    @State private var selectedIce:TempUnit = .lukeWarm

    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack{
                Menu {
                    ForEach(TempUnit.allCases, id: \.self) { temp in
                        Button {
                            store.send(.setDrinkTemp(temp))
                            selectedIce = temp
                        } label: {
                            Text(temp.rawValue)
                                .font(Font.custom("jf-openhuninn-2.1", size: 18))
                        }
                    }
                } label: {
                    
                    HStack {
                        Text(store.cartEditItem.tempUnit.rawValue)
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
            
            Text("冰度")
                .font(Font.custom("jf-openhuninn-2.1", size: 18))
                .padding([.horizontal], 5)
                .foregroundStyle(.sub)
                .background(.main)
                .padding([.horizontal])
        }
        .padding()
    }
}


#Preview {
    IceMenu(store: .init(initialState: CartEditDomain.State.previewState(), reducer: {
        CartEditDomain()
    }))
}
