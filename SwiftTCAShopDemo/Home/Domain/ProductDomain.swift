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
    struct State:Equatable,Identifiable {
        var id:UUID
        var product:Product
        
    }
    enum Action {
        case readProduct
    }
    
    var body:some Reducer<State,Action> {
        Reduce { state, action in
            switch action {
              case .readProduct:
                return .none
            }
        }
    }
}
