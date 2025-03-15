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
    struct State: Equatable, Identifiable {
        var id: UUID
        var cartItem: CartItem
        var mPrice: Int?
        var lPrice: Int?
    }
    
    enum Action: Equatable {
        case incrementQuantity
        case decrementQuantity
        case changeSugar(SugarUnit)
        case changeTemp(TempUnit)
        case changeSize(SizeUnit)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementQuantity:
                state.cartItem.quantity += 1
                return .none
                
            case .decrementQuantity:
                if state.cartItem.quantity > 1 {
                    state.cartItem.quantity -= 1
                }
                return .none
                
            case .changeSugar(let sugar):
                state.cartItem.sugarUnit = sugar
                return .none
                
            case .changeTemp(let temp):
                state.cartItem.tempUnit = temp
                return .none
                
            case .changeSize(let size):
                state.cartItem.size = size
                
                switch size {
                case .M:
                    if let mPrice = state.mPrice {
                        state.cartItem.price = mPrice
                    }
                case .L:
                    if let lPrice = state.lPrice {
                        state.cartItem.price = lPrice
                    }
                }
                
                return .none
            }
        }
    }
}
