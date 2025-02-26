//
//  CartDomain.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/24.
//


import Foundation
import ComposableArchitecture

@Reducer
struct CartItemDomain {
    
    @ObservableState
    struct State:Equatable,Identifiable{
        var id:UUID
        var cartItem:CartItem
    }
    
    enum Action:Equatable {
        case initAddedItem(product:Product)
    }
 
    var body:some Reducer<State,Action> {
        Reduce { state, action in
            switch action {
            case .initAddedItem(product: let _):
                return .none
            }
        }
    }
    
}
