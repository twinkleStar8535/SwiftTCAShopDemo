//
//  CartEditDomain.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/25.
//


import Foundation
import ComposableArchitecture

@Reducer
struct CartEditDomain {
    
    @ObservableState
    struct State: Equatable {
        var cartEditItem: CartItem
        var count: Int = 1
        var mPrice: Int?
        var lPrice: Int?
        var totalPrice: Int {
            cartEditItem.price * cartEditItem.quantity
        }
    }
    
    enum Action: Equatable {
        case initCartBy(Drink)
        case setUserName(String)
        case setDrinkSize(SizeUnit)
        case setPrices(mPrice: Int?, lPrice: Int?)
        case setDrinkSugar(SugarUnit)
        case setDrinkTemp(TempUnit)
        case addCountWhenTapped
        case minusCountWhenTapped
        case saveButtonTapped
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case addToListItems(CartItem)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .initCartBy(_):
                return .none
                
            case .setUserName(let name):
                state.cartEditItem.userName = name
                return .none
                
            case .setDrinkSize(let size):
                state.cartEditItem.size = size
                
                switch size {
                case .M:
                    if let mPrice = state.mPrice {
                        state.cartEditItem.price = mPrice
                    }
                case .L:
                    if let lPrice = state.lPrice {
                        state.cartEditItem.price = lPrice
                    }
                }
                return .none
                
            case .setPrices(let mPrice, let lPrice):
                state.mPrice = mPrice
                state.lPrice = lPrice
                
                switch state.cartEditItem.size {
                case .M:
                    if let mPrice = mPrice {
                        state.cartEditItem.price = mPrice
                    }
                case .L:
                    if let lPrice = lPrice {
                        state.cartEditItem.price = lPrice
                    }
                }
                return .none
                
            case .setDrinkSugar(let sugar):
                state.cartEditItem.sugarUnit = sugar
                return .none
                
            case .setDrinkTemp(let temp):
                state.cartEditItem.tempUnit = temp
                return .none
                
            case .addCountWhenTapped:
                state.count += 1
                state.cartEditItem.quantity = state.count
                return .none
                
            case .minusCountWhenTapped:
                if state.count > 1 {
                    state.count -= 1
                    state.cartEditItem.quantity = state.count
                }
                return .none
                
            case .saveButtonTapped:
                return .run { [cartItem = state.cartEditItem] send in
                    await send(.delegate(.addToListItems(cartItem)))
                    await self.dismiss()
                }
                
            case .delegate:
                return .none
            }
        }
    }
}


extension CartEditDomain.State {
    static func previewState() -> CartEditDomain.State {
        let item = CartItem(
            id: UUID(),
            drinkImage: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/焙香大麥拿鐵.png",
            drinkName: "焙香大麥拿鐵",
            userName: "",
            size: .M,
            sugarUnit: .halfSugar,
            tempUnit: .lessIce,
            price: 50,
            quantity: 1
        )
        
        var state = CartEditDomain.State(cartEditItem: item)
        state.mPrice = 50
        state.lPrice = 60
        return state
    }
}
