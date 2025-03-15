//
//  CartHistoryDomain.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/28.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct CartHistoryDomain {
    
    @ObservableState
    struct State:Equatable,Identifiable {
        var id:UUID
        var cartOrderItems:IdentifiedArrayOf<CartItemDomain.State> = []
    }
    
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.uuid) var uuid
    
    enum Action :Equatable{
        case startShowCartOrder
        case fetchAllCartOrder(TaskResult<[CartItem]>)
    }
    
    var body:some Reducer<State,Action> {
        Reduce { state, action in
            switch action {
            case .startShowCartOrder:
                return .run { send in
                    await send(.fetchAllCartOrder(TaskResult{
                        guard let allHistoryOrders = try? await apiClient.fetchDrinkOrder() else {
                            print("Fetch Order Error")
                            return []
                        }
                        return allHistoryOrders
                    }))
                }
            case .fetchAllCartOrder(.success(let fullOrders)):
                let allOrders = fullOrders.map { cartItem in
                    CartItemDomain.State(id: uuid(), cartItem: cartItem)
                }
                state.cartOrderItems = IdentifiedArrayOf(uniqueElements: allOrders)
                
                return .none
            case .fetchAllCartOrder(.failure(let error)):
                print("Fetch Order Have Error :\(error)")
                return .none
            }
        }
    }
    
}
