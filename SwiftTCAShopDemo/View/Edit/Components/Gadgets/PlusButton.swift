//
//  PlusButton.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/21.
//

import SwiftUI
import ComposableArchitecture


struct PlusButton:View {

    let store:StoreOf<CartEditDomain>
    
    var body: some View {
        
        HStack {
            Button {
                store.send(.minusCountWhenTapped)
            } label: {
                Text("-")
                    .font(Font.custom("jf-openhuninn-2.1", size: 18))
                    .padding(10)
                    .background(.sub)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }.buttonStyle(.plain)

            Text(store.state.count.description)
                .font(Font.custom("jf-openhuninn-2.1", size: 18))
                .foregroundStyle(.white)
            
            Button {
                store.send(.addCountWhenTapped)
            } label: {
                Text("+")
                    .font(Font.custom("jf-openhuninn-2.1", size: 18))
                    .padding(10)
                    .background(.sub)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }.buttonStyle(.plain)
        }
    }
}

#Preview {
    PlusButton(store:.init(initialState: CartEditDomain.State.previewState(), reducer: {
        CartEditDomain()
    }))
}

