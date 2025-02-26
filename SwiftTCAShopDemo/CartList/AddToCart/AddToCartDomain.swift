//
//  AddToCartDomain.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/21.
//

import Foundation
import ComposableArchitecture


@Reducer
struct AddToCartDomain {
    
    @ObservableState
    struct State :Equatable {
        var count:Int = 0
    }

    enum Action:Equatable {
        case addCountWhenTapped
        case minusCountWhenTapped
    }
    
    var body:some Reducer <State,Action> {
        Reduce { state, action in
            switch action {
            case .addCountWhenTapped:
                state.count += 1
                return .none
            case .minusCountWhenTapped:
                state.count -= 1
                return .none
            }
        }
    }
    
}
