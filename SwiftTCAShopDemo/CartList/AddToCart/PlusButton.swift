//
//  PlusButton.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/21.
//

import SwiftUI
import ComposableArchitecture


struct PlusButton:View {

   let store:StoreOf<AddToCartDomain>
    
    var body: some View {
        
        HStack {
            Button {
                store.send(.minusCountWhenTapped)
            } label: {
                Text("-")
                    .padding(10)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }.buttonStyle(.plain)

            Text(store.state.count.description)
            
            Button {
                store.send(.addCountWhenTapped)
            } label: {
                Text("+")
                    .padding(10)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }.buttonStyle(.plain)
        }
    }
}

#Preview {
    PlusButton(store: .init(initialState: AddToCartDomain.State(), reducer: {
        AddToCartDomain()
    }))
}

