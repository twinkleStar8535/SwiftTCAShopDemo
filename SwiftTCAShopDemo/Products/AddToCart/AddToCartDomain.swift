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
    
    @ObservableState  // 如果我使用ObservableState ,要使用時就不需要用WithViewStore / WithPerceptionTracking 追蹤
    struct State:Equatable {
        var count:Int = 0 
    }
    
    enum Action:Equatable {
        case addCountWhenTapped
        case dropCountWhenTapped
    }
    
    // Current best method : 可以使用Scope(state:,action:) 直接在母Domain 直接提取子 Domain 的 Reducer
    var body:some Reducer<State,Action> {
        Reduce { state, action in
            switch action {
               case .addCountWhenTapped:
                 state.count += 1
                 return .none
              case .dropCountWhenTapped:
                state.count -= 1
                return .none
            }
        }
    }

    // Default Method 
//    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.Effect<Action> {
//        switch action {
//        case .addCountWhenTapped:
//            state.count += 1
//            return .none
//        case .dropCountWhenTapped:
//            state.count -= 1
//            return .none
//        }
//    }
    
    
}


/*
// Old Method
 
 static let reducer = Reduce<State,Action> { state, action in
     switch action {
     case .addCountWhenTapped:
         state.count += 1
         return .none
     case .dropCountWhenTapped:
         state.count -= 1
         return .none
     }
 }
 */

