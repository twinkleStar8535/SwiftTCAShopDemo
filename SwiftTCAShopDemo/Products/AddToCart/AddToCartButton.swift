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

    var body:some View {
        
        if (store.count > 0) {
            PlusButton(store: store)
                .frame(height: 80)
        } else {
            Button {
                store.send(.addCountWhenTapped)
            } label: {
                Text("Add To Cart")
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .frame(height: 80)
                    .cornerRadius(10)
            }
        }
    }
    
}

#Preview {
    AddToCartButton(store: .init(initialState: AddToCartDomain.State(), reducer: {
        AddToCartDomain()
    }))
}
