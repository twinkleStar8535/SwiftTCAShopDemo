//
//  CartHistoryListView.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/26.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct CartHistoryListView :View {
    
    @Bindable var store:StoreOf<CartHistoryDomain>
    
    var body: some View {
        VStack {
            if !store.cartOrderItems.isEmpty {
                cartOrderList
            } else {
                Spacer()
                Text("沒有消費記錄")
                    .foregroundStyle(.white)
                Spacer()
            }
        }
        .background(.main)
    }
    
    
    private var cartOrderList: some View {
        ScrollView {
            LazyVStack {
                ForEach(store.cartOrderItems) { itemState in
                    CartHistoryCardView(item: itemState.cartItem)
                }
            }.padding(.top)
        }
    }
}
