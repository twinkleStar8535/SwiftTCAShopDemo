//
//  CartModifyDomain.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/3/2.
//


import SwiftUI
import ComposableArchitecture


@Reducer
struct CartModifyDomain {
    
    @ObservableState
    struct State: Equatable, Identifiable {
        var id: UUID
        var sendItems: IdentifiedArrayOf<CartItemDomain.State>
        
        var totalOrderPrice: Int {
            sendItems.reduce(0) { total, itemState in
                total + (itemState.cartItem.price * itemState.cartItem.quantity)
            }
        }
    }
    
    enum Action: Equatable {
        case startGetItems([CartItem])
        case sendOrder
        
        case updateCartItem(id: UUID, quantity: Int)
        case updateSugarLevel(id: UUID, sugar: SugarUnit)
        case updateTempUnit(id: UUID, temp: TempUnit)
        case updateSize(id: UUID, size: SizeUnit, price: Int)
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case cleanSendItems
        }
    }
    
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.isPresented) var isPresented
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startGetItems(let items):
                state.sendItems = IdentifiedArrayOf(uniqueElements: items.map { item in
                    CartItemDomain.State(id: item.id, cartItem: item)
                })
                return .none
                
            case .sendOrder:

                guard !state.sendItems.isEmpty else {
                    return .none
                }
                
                let sendItems = state.sendItems.map { cartDomain in
                    return cartDomain.cartItem
                }
                
                return .run { send in
                    try await apiClient.sendDrinkOrder(sendItems)
                    await send(.delegate(.cleanSendItems))
                }
                
            case .updateCartItem(let id, let quantity):
                if let index = state.sendItems.firstIndex(where: { $0.id == id }) {
                    state.sendItems[index].cartItem.quantity = quantity
                }
                return .none
                
            case .updateSugarLevel(let id, let sugar):
                if let index = state.sendItems.firstIndex(where: { $0.id == id }) {
                    state.sendItems[index].cartItem.sugarUnit = sugar
                }
                return .none
                
            case .updateTempUnit(let id, let temp):
                if let index = state.sendItems.firstIndex(where: { $0.id == id }) {
                    state.sendItems[index].cartItem.tempUnit = temp
                }
                return .none
                
            case .updateSize(let id, let size, let price):
                if let index = state.sendItems.firstIndex(where: { $0.id == id }) {
                    state.sendItems[index].cartItem.size = size
                    state.sendItems[index].cartItem.price = price
                }
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
