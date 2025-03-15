//
//  AddToCartButton.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/21.
//

import SwiftUI
import ComposableArchitecture

struct AddToCartButton:View {
    
    var store:StoreOf<CartEditDomain>
    var addAction:() -> Void
    var minusAction:() -> Void
    
    var body: some View {
        
        if (store.state.count > 0) {
            PlusButton(store: store)
        } else {
            Button {
                store.send(.addCountWhenTapped)
            } label: {
                Text("Add")
                    .font(Font.custom("jf-openhuninn-2.1", size: 18))
                    .padding(10)
                    .background(.sub)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }.buttonStyle(.plain)
            
        }
    }
    
}

#Preview {
    AddToCartButton(store:.init(initialState: CartEditDomain.State.previewState(), reducer: {
        CartEditDomain()
    }),addAction: {},minusAction: {})
}
