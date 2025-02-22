//
//  PlusButton.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/21.
//

import SwiftUI
import ComposableArchitecture


struct PlusButton:View {
    
    // AddToCartDomain 遵從 Protocol Reducer , 可以直接用 typealias StoreOf<T>
    
   let store:StoreOf<AddToCartDomain>
    
    // 若沒遵從 Protocol Reducer 要把完整的State,Action 寫出來
 //  let store :Store<AddToCartDomain.State,AddToCartDomain.Action>

    var body: some View {
        
  // 'WithPerceptionTracking 在 ObservableState 出來後 (iOS 17 ) 且符合 Protocol Reducer可省略
 //     WithPerceptionTracking {
            HStack{
                Button {
                    store.send(.dropCountWhenTapped)
                } label: {
                    Text("-")
                        .padding(10)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
                
                Text(store.count.description)
                
                Button {
                    store.send(.addCountWhenTapped)
                } label: {
                    Text("+")
                        .padding(10)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
            }
//        }
    }
    
    
}


#Preview {

    PlusButton(store: Store(initialState: AddToCartDomain.State(), reducer: {
        AddToCartDomain()
      }))
}

