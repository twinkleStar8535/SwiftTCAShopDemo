//
//  DrinkDomain.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/22.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DrinkDomain {

    @ObservableState
    struct State:Equatable,Identifiable {
        var id:UUID
        var drink:Drink
        
    }
    enum Action {
        case readDrink
    }
    
    var body:some Reducer<State,Action> {
        Reduce { state, action in
            switch action {
              case .readDrink:
                return .none
            }
        }
    }
}
