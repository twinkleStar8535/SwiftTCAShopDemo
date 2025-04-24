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
        @Presents var alert: AlertState<Action.Alert>?
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
        case alert(PresentationAction<Alert>)
        
        enum Delegate: Equatable {
            case cleanSendItems
        }
        enum Alert: Equatable {
            case emptyCart
            case zeroQuantity
        }
    }
    
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startGetItems(let items):
                state.sendItems = IdentifiedArrayOf(uniqueElements: items.map { item in
                    CartItemDomain.State(id: item.id, cartItem: item)
                })
                return .none
                
            case .sendOrder:
                if state.sendItems.isEmpty {
                    state.alert = AlertState(title: {
                        TextState("通知")
                    },actions: {
                        ButtonState(role: .cancel) {
                            TextState("啊呀我迷糊了!")
                        }
                    },message: {
                        TextState("購物車完全沒東西")
                    })
                    return .none
                }
                
                if state.sendItems.contains(where: { $0.cartItem.quantity == 0 }) {
                    
                    state.alert = AlertState(title: {
                        TextState("通知")
                    },actions: {
                        ButtonState(role: .cancel) {
                            TextState("喔喔喔好! 我去補")
                        }
                    },message: {
                        TextState("有商品數量為0，請調整數量")
                    })
                    
                    return .none
                    
                } else {
                    
                    let sendItems = state.sendItems.map { cartDomain in
                        return cartDomain.cartItem
                    }
                    
                    return .run { send in
                        try await apiClient.sendDrinkOrder(sendItems)
                        await send(.delegate(.cleanSendItems))
                        await self.dismiss()
                    }
                    
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
                
            case .alert:
                return .none
            }
        }
        .ifLet(\.alert, action: \.alert)
    }
}
