//
//  AddToCartButton.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/21.
//

import SwiftUI
import ComposableArchitecture


struct AddToCartButton:View {
    
    let store:StoreOf<AddToCartDomain>
    
    var body: some View {
        
        if (store.state.count > 0) {
            PlusButton(store: store)
        } else {
            Button {
                store.send(.addCountWhenTapped)
            } label: {
                Text("Add to Cart")
                    .padding(10)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }.buttonStyle(.plain)
            
        }
    }
    
}

#Preview {
    AddToCartButton(store: .init(initialState: AddToCartDomain.State(), reducer: {
        AddToCartDomain()
    }))
}
