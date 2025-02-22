//
//  ProductDomain.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/22.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ProductDomain {
    @ObservableState
    struct State:Equatable,Identifiable{
        let id:UUID
        let product:Product
        var addToCartState = AddToCartDomain.State()
    }

    enum Action:Equatable{
        case changeCartAction(AddToCartDomain.Action)
    }
    
    var body:some Reducer<ProductDomain.State,ProductDomain.Action> {
        
        Scope(state: \.addToCartState, action: \.changeCartAction) {
            AddToCartDomain()
        }
    
        Reduce { state, action in
            switch action {
              case .changeCartAction (.addCountWhenTapped):
                return .none
              case .changeCartAction (.dropCountWhenTapped):
                state.addToCartState.count = max(0,state.addToCartState.count)
                return .none
            }
        }
    }
    
}
