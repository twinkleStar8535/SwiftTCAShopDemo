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
    struct State:Equatable {
        // Loading Sttate
        var dataLoadingStatus = DataLoadingStatus.notStarted
        var shouldShowError: Bool {
            dataLoadingStatus == .error
        }
        var isLoading: Bool {
            dataLoadingStatus == .loading
        }
        
        // Product State
        var productList:IdentifiedArrayOf<ProductDomain.State> = []
        var fetchedCategory:[String] = []
        var selectedCategory:String?
        var showProductsByCategory:[ProductCategory] = []
        
        // Edit Single Order
        @Presents var cartEditState:CartEditDomain.State?
    }
    
    enum Action:Equatable {
        // Fetch Drink For Home
        case startFetchDrink
        case fetchAllProduct(TaskResult<[ProductCategory]>)
        
        //  Filter Drink By Category
        case selectCategory(String)
        case filterProducts(String)
        case forEachProduct(IdentifiedActionOf<ProductDomain>)
        
        // Present Single order
        case initializeCartBy(PresentationAction<CartEditDomain.Action>)
    }
    
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.uuid) var uuid
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
           Reduce { state, action in
               doFullreduce(state: &state, action: action)
           }
           .forEach(\.productList, action: \.forEachProduct) { ProductDomain() }
           .ifLet(\.$cartEditState, action: \.initializeCartBy) { CartEditDomain() }
       }

       private func doFullreduce(state: inout State, action: Action) -> Effect<Action> {
           switch action {
           case .startFetchDrink:
               print("Start Loading Drink")
               return .run { send in
                   await send(.fetchAllProduct(TaskResult {
                       guard let fullCategory = try? await self.apiClient.getAllDrinkFromCatrgory() else {
                           print("Fetch Drink Error")
                           return []
                       }
                       return fullCategory
                   }))
               }
           case .fetchAllProduct(.success(let fullCategoryWithDrink)):
               print("Fetch All Drink Items")
               state.showProductsByCategory = fullCategoryWithDrink

               state.fetchedCategory = fullCategoryWithDrink.map(\.category)
               state.fetchedCategory.insert("全部", at: 0)
               state.selectedCategory = "全部"

               let allProducts = fullCategoryWithDrink.flatMap { category in
                   category.products.map { product in
                       ProductDomain.State(id: uuid(), product: product)
                   }
               }

               state.productList = IdentifiedArrayOf(uniqueElements: allProducts)
               return .none

           case .fetchAllProduct(.failure(let error)):
               print("Fetch Drink Have Error :\(error)")
               return .none
           case .selectCategory(let category):
               print("Picked Category :\(category)")
               return .run { send in
                   await send(.filterProducts(category))
               }

           case .filterProducts(let filterCategory):               
               if filterCategory == "全部" {
                   let allProducts = state.showProductsByCategory.flatMap { category in
                       category.products.map { product in
                           ProductDomain.State(id: uuid(), product: product)
                       }
                   }
                   state.productList = IdentifiedArray(uniqueElements: allProducts)

               } else {
                   if let filteredProducts = state.showProductsByCategory
                       .first(where: { $0.category == filterCategory })
                       .flatMap({ category in
                           category.products.map { product in
                               ProductDomain.State(id: uuid(), product: product)
                           }
                       })
                   {
                       state.productList = IdentifiedArray(uniqueElements: filteredProducts)
                   }
               }
               return .none
           case .initializeCartBy(.presented(.loadFrom(let product))):
               var initSize = ""

               if product.prices.mPrice != nil {
                   initSize = "M"
               } else {
                   initSize = "L"
               }

               state.cartEditState = CartEditDomain.State(
                   cartItem: CartItem(
                       drinkImage: product.img,
                       drinkName: product.name,
                       size: initSize,
                       userName: "",
                       sugarUnit: .halfSugar,
                       soldMPrice: product.prices.mPrice,
                       soldLPrice: product.prices.lPrice,
                       quantity: 1
                   )
               )
               return .none
           case .initializeCartBy(.dismiss):
               state.cartEditState = nil
               return .none
           case .initializeCartBy(.presented(.saveButtonTapped)):
               state.cartEditState = nil
               return .none
           case .forEachProduct(_):
               return .none
           }
       }
   }
