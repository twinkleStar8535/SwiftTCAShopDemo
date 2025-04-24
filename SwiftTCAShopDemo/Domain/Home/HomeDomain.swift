//
//  HomeDomain.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/23.
//


import Foundation
import ComposableArchitecture

@Reducer
struct HomeDomain {
    
    @ObservableState
    struct State: Equatable {
        var showDrinkList: IdentifiedArrayOf<DrinkDomain.State> = []
        var fetchedCategory: [String] = []
        var selectedCategory: String = ""
        var allDrinkStorage: [DrinkCategory] = []
        
        var cartCardItemsBox: IdentifiedArrayOf<CartItem> = []
        var drinkPricesMap: [UUID: (mPrice: Int?, lPrice: Int?)] = [:]
        var path = StackState<CartModifyDomain.State>()
        
        static func == (lhs: State, rhs: State) -> Bool {
            lhs.showDrinkList == rhs.showDrinkList &&
            lhs.fetchedCategory == rhs.fetchedCategory &&
            lhs.selectedCategory == rhs.selectedCategory &&
            lhs.allDrinkStorage == rhs.allDrinkStorage &&
            lhs.cartCardItemsBox == rhs.cartCardItemsBox &&
            lhs.path == rhs.path
        }
        
        @Presents var cartEditState: CartEditDomain.State?
    }
    
    enum Action: Equatable {
        
        case startFetchDrink
        case fetchAllDrink(TaskResult<[DrinkCategory]>)
        case loopEachDrink(IdentifiedActionOf<DrinkDomain>)
        case selectCategory(String)
        case filterDrinks(String)
        case setCartOrderBy(PresentationAction<CartEditDomain.Action>)
        case prepareCartListState
        case path(StackActionOf<CartModifyDomain>)
    }
    
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.uuid) var uuid
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                // MARK: 首頁飲料顯示
            case .startFetchDrink, .fetchAllDrink, .selectCategory, .filterDrinks:
                return presentHomeDrink(state: &state, action: action)
                
                // MARK: 跳轉至下單頁顯示資料
            case .setCartOrderBy(.presented(.initCartBy(let drink))):
                return presentInitCartOrder(state: &state, drink: drink)
                
                // MARK: 每筆下單頁確認後的結果,從子頁面透過 delegate 方式傳回來處理加入到總訂單的資料
            case .setCartOrderBy(.presented(.delegate(.addToListItems(let item)))):
                let drink = state.allDrinkStorage.flatMap { $0.drinks }.first { $0.name == item.drinkName }
                return handleAddToListItems(state: &state, item: item, mPrice: drink?.prices.mPrice, lPrice: drink?.prices.lPrice)

            case .prepareCartListState:
                return prepareCartListState(state: &state)
             
            case .path(.element(id: _, action: .delegate(.cleanSendItems))):
                state.cartCardItemsBox.removeAll()
                state.drinkPricesMap.removeAll()
                state.path.removeAll()
                return .none
                
            case .loopEachDrink:
                return .none
                
            case .setCartOrderBy:
                return .none
                
            case .path:
                return .none
            }
        }
        .forEach(\.showDrinkList, action: \.loopEachDrink) {
            DrinkDomain()
        }
        .ifLet(\.$cartEditState, action: \.setCartOrderBy) {
            CartEditDomain()
        }
        .forEach(\.path, action: \.path) {
            CartModifyDomain()
        }
    }
    
    // MARK: 處理開啟App 首頁飲料顯示
    private func presentHomeDrink(state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .startFetchDrink:
            return .run { send in
                await send(.fetchAllDrink(TaskResult {
                    guard let fullCategory = try? await self.apiClient.getAllDrinks() else {
                        print("Fetch Drink Error")
                        return []
                    }
                    return fullCategory
                }))
            }
            
        case .fetchAllDrink(.success(let fullDrinks)):
            return handleFetchAllDrinkSuccess(state: &state, fullDrinks: fullDrinks)
            
        case .fetchAllDrink(.failure(let error)):
            print("Fetch Drink Have Error :\(error)")
            return .none
            
        case .selectCategory(let category):
            return .run { send in
                await send(.filterDrinks(category))
            }
            
        case .filterDrinks(let filterCategory):
            return handleFilterDrinks(state: &state, filterCategory: filterCategory)
            
        default:
            return .none
        }
    }
    
    private func handleFetchAllDrinkSuccess(state: inout State, fullDrinks: [DrinkCategory]) -> Effect<Action> {
        print("Fetch All Drink Items")
        state.allDrinkStorage = fullDrinks
        
        state.fetchedCategory = fullDrinks.map(\.category)
        state.fetchedCategory.insert("全部", at: 0)
        state.selectedCategory = "全部"
        
        let allDrinks = fullDrinks.flatMap { category in
            category.drinks.map { drink in
                DrinkDomain.State(id: uuid(), drink: drink)
            }
        }
        
        state.showDrinkList = IdentifiedArrayOf(uniqueElements: allDrinks)
        return .none
    }
    
    private func handleFilterDrinks(state: inout State, filterCategory: String) -> Effect<Action> {
        if filterCategory == "全部" {
            let allDrinks = state.allDrinkStorage.flatMap { category in
                category.drinks.map { drink in
                    DrinkDomain.State(id: uuid(), drink: drink)
                }
            }
            state.showDrinkList = IdentifiedArray(uniqueElements: allDrinks)
        } else {
            if let filteredDrinks = state.allDrinkStorage
                .first(where: { $0.category == filterCategory })
                .flatMap({ category in
                    category.drinks.map { drink in
                        DrinkDomain.State(id: uuid(), drink: drink)
                    }
                })
            {
                state.showDrinkList = IdentifiedArray(uniqueElements: filteredDrinks)
            }
        }
        return .none
    }
    
    // MARK: 處理跳轉至下單頁顯示資料
    
    private func presentInitCartOrder(state: inout State, drink: Drink) -> Effect<Action> {
        state.cartEditState = self.initializeCartEditState(drink: drink)
        return .none
    }
    
    private func initializeCartEditState(drink: Drink) -> CartEditDomain.State {
        var initSize: SizeUnit = .M
        var price = 0

        if drink.prices.mPrice != nil {
            initSize = .M
            price = drink.prices.mPrice!
        } else {
            initSize = .L
            price = drink.prices.lPrice!
        }
        
        var state = CartEditDomain.State(
            cartEditItem: CartItem(
                id: uuid(),
                drinkImage: drink.img,
                drinkName: drink.name,
                userName: "",
                size: initSize,
                sugarUnit: .halfSugar,
                tempUnit: .lukeWarm,
                price: price,
                quantity: 1
            )
        )
        
        state.mPrice = drink.prices.mPrice
        state.lPrice = drink.prices.lPrice
        
        return state
    }
    
    
    // MARK: 這邊使用 cartCardItemsBox蒐集 全部下訂的紀錄, 跟mapping 飲料價格, 另外上一個頁面編輯已完成要先將state 清為 nil
    private func handleAddToListItems(state: inout State, item: CartItem, mPrice: Int?, lPrice: Int?) -> Effect<Action> {
        state.cartCardItemsBox.append(item)
        state.drinkPricesMap[item.id] = (mPrice, lPrice)
        state.cartEditState = nil
        return .none
    }

    
    private func prepareCartListState(state: inout State) -> Effect<Action> {
        let cartItems = state.cartCardItemsBox.map { item in
            let prices = state.drinkPricesMap[item.id] ?? (nil, nil)

            var cartItem = item
            cartItem.soldMPrice = prices.mPrice
            cartItem.soldLPrice = prices.lPrice

            return CartItemDomain.State(
                id: item.id,
                cartItem: cartItem,
                mPrice: prices.mPrice,
                lPrice: prices.lPrice
            )
        }

        let cartListState = CartModifyDomain.State(
            id: uuid(),
            sendItems: IdentifiedArrayOf(uniqueElements: cartItems)
        )

        state.path.append(cartListState)
        return .none
    }
}
