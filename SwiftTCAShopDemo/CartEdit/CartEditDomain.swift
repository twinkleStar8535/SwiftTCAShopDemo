//
//  CartEditDomain.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/25.
//


import Foundation
import ComposableArchitecture

@Reducer
struct CartEditDomain{
    
    @ObservableState
    struct State:Equatable{
        var cartItem:CartItem
    }
    
    enum Action:Equatable {
        case loadFrom(Product)
        case saveButtonTapped
    }
 
    var body:some Reducer<State,Action> {
        Reduce { state, action in
            switch action {
            case .loadFrom(_):
                return .none
            case .saveButtonTapped:
                return .none
            }
        }
    }
    
}
