//
//  SizeMenu.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture

struct SizeMenu: View {
    
    @Bindable var store: StoreOf<CartEditDomain>
    @State private var selectedSize: SizeUnit = .M

    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack {
                Menu {

                    if store.mPrice != nil {
                        Button {
                            store.send(.setDrinkSize(.M))
                            selectedSize = .M
                        } label: {
                            Text(SizeUnit.M.rawValue)
                                .font(Font.custom("jf-openhuninn-2.1", size: 18))
                        }
                    }
                    
                    if store.lPrice != nil {
                        Button {
                            store.send(.setDrinkSize(.L))
                            selectedSize = .L
                        } label: {
                            Text(SizeUnit.L.rawValue)
                                .font(Font.custom("jf-openhuninn-2.1", size: 18))
                        }
                    }
                } label: {
                    HStack {
                        Text(store.cartEditItem.size.rawValue)
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
            
            Text("大小")
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
    SizeMenu(store: .init(initialState: CartEditDomain.State.previewState(), reducer: {
        CartEditDomain()
    }))
}
