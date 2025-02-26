//
//  CartListDomain.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CartListDomain{
    
    @ObservableState
    struct State:Equatable,Identifiable {
        var id:UUID
        var cartItem:IdentifiedArrayOf<CartItemDomain.State> = []
    }
    
    enum Action :Equatable{
        case startShowCartList
    }
    
    var body:some Reducer<State,Action> {
        Reduce { state, action in
            switch action {
             case .startShowCartList:
                return .none
            }
        }
    }
    
}
