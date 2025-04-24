//
//  HomeView.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/23.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @Bindable var store: StoreOf<HomeDomain>
    @Bindable var historyStore: StoreOf<CartHistoryDomain>
    
    var columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var showingCartList = false

    
    var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: \.path)) {
            mainContent
        } destination: { store in
            CartModifyListView(store: store)
        }
        .accentColor(.white)
        .sheet(item: $store.scope(state: \.cartEditState, action: \.setCartOrderBy)) { cartEditDomain in
            NavigationStack {
                CartEditView(store: cartEditDomain)
            }
        }
    
    }
    
    private var mainContent: some View {
        VStack {
            ScrollView {
                headerView
                categoryScrollView
                drinkGridView
            }
        }
        .overlay(alignment: .bottomTrailing, content: {
            Button {
                store.send(.prepareCartListState)
            } label: {
                FloatCartView().overlay {
                    (store.cartCardItemsBox.count > 0 ? Badge(count: store.cartCardItemsBox.count) : nil)
                }
            }
            .tint(.white)
            .padding(30)
        })
        .background(Color("MainColor"))
    }
    
    private var headerView: some View {
        HStack(alignment: .center) {
            Image(uiImage: UIImage(named: "modifiedLogo")!)
                .resizable()
                .scaledToFit() 
                .frame(width: 100, height: 80)
                .padding(.leading, 10)

            Spacer()

            cartButton
        }
    }
    
    private var cartButton: some View {
        NavigationLink {
            CartHistoryListView(store: historyStore)
        } label: {
            HStack {
                Image(systemName: "basket.fill")
                    .tint(.white)
                    .padding(.leading, 10)
                Text("購物記錄")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.trailing, 5)
            }
            .task({
                historyStore.send(.startShowCartOrder)
            })
            .padding()
        }
    }
    
    private var categoryScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(store.fetchedCategory, id: \.self) { category in
                    DrinkSegment(onTap: {
                        store.send(.selectCategory(category))
                    }, segmentTitle: category)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 50)
    }
    
    private var drinkGridView: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(store.showDrinkList) { eachItem in
                Button {
                    store.send(.setCartOrderBy(.presented(.initCartBy(eachItem.drink))))
                } label: {
                    DrinkCell(drink: eachItem.drink)
                }
            }
        }
        .task {
            store.send(.startFetchDrink)
        }
        .padding()
    }
    
}

#Preview {
    HomeView(
        store: .init(
            initialState: HomeDomain.State(),
            reducer: { HomeDomain() },
            withDependencies: { dependency in
                dependency.apiClient.getAllDrinks = { DrinkCategory.sample }
            }
        ), historyStore: .init(
            initialState: CartHistoryDomain.State(id: UUID()),
            reducer: { CartHistoryDomain() },
            withDependencies: { dependency in
                dependency.apiClient.fetchDrinkOrder = { CartItem.previewState() }
            }
        ),
        columns: [GridItem(.flexible()), GridItem(.flexible())]
    )
}
