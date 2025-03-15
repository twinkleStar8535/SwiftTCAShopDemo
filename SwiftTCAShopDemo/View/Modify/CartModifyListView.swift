//
//  CartModifyListView.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/26.
//


import SwiftUI
import ComposableArchitecture


struct CartModifyListView: View {
    @Bindable var store: StoreOf<CartModifyDomain>
    var onDismiss: () -> Void 

    var body: some View {
        VStack {
            if !store.sendItems.isEmpty {
                cartItemsList
            } else {
                Spacer()
                Text("購物車沒有商品")
                    .foregroundStyle(.white)
                Spacer()
            }
            checkoutSection
        }
        .background(.main)
    }
    
    private var cartItemsList: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(store.sendItems) { itemState in
                    CartModifyCardView(item: itemState) {
                        store.send(.updateCartItem(id: itemState.id, quantity: itemState.cartItem.quantity + 1))
                    } onDecrement: {
                        var realQuantity = 0
                        if (itemState.cartItem.quantity <= 1) {
                            realQuantity = 0
                        } else {
                            realQuantity = itemState.cartItem.quantity - 1
                        }
                        store.send(.updateCartItem(id: itemState.id, quantity: realQuantity))
                    } onSugarChange: { sugar in
                        store.send(.updateSugarLevel(id: itemState.id, sugar: sugar))
                    } onTempChange: { temp in
                        store.send(.updateTempUnit(id: itemState.id, temp: temp))
                    } onSizeChange: { newSize, newPrice in
                        store.send(.updateSize(id: itemState.id, size: newSize, price: newPrice))
                    }
                }
            }
            .padding(.top)
        }
    }
    
    private var checkoutSection: some View {
        VStack {
            Divider()
                .background(.white.opacity(0.3))
                .padding(.horizontal)
            
            HStack {
                Text("總金額:")
                    .font(Font.custom("jf-openhuninn-2.1", size: 20))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("NT$ \(store.totalOrderPrice)")
                    .font(Font.custom("jf-openhuninn-2.1", size: 20))
                    .foregroundStyle(.white)
                    .bold()
            }
            .padding()
            
            Button(action: {
                store.send(.sendOrder)
                if !store.sendItems.isEmpty {
                    onDismiss()
                 }
            }) {
                Text("送出訂單")
                    .font(Font.custom("jf-openhuninn-2.1", size: 18))
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.sub)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(.main.shadow(.inner(color: .black.opacity(0.6), radius: 10)))
    }
}


#Preview {
    CartModifyListView(store: .init(initialState: CartModifyDomain.State(id: UUID(), sendItems: IdentifiedArray(uniqueElements: [
        CartItemDomain.State(id: UUID(), cartItem: CartItem(id: UUID(), drinkImage: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/焙香大麥拿鐵.png",
                                                            drinkName: "焙香大麥拿鐵",
                                                            userName: "ABC", size: .M, sugarUnit: .halfSugar,
                                                            tempUnit: .lessIce,price: 0, quantity: 1)),
        CartItemDomain.State(id: UUID(), cartItem: CartItem(id: UUID(), drinkImage: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/輕纖蕎麥拿鐵.png",
                                                            drinkName: "輕纖蕎麥拿鐵",
                                                            userName: "DEF", size: .L, sugarUnit: .halfSugar,
                                                            tempUnit: .lessIce,price: 0, quantity: 1))]
      )
    ) , reducer: {
        CartModifyDomain()
    }),onDismiss: {})
}
