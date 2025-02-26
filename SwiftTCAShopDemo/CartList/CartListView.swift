//
//  CartListView.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/26.
//


import SwiftUI
import ComposableArchitecture


struct CartListView {
    
    @Bindable var store :StoreOf<CartItemDomain>
    
    var body:some View {
        
        ScrollView{
            VStack {
                
                AsyncImage(url: URL(string: store.cartItem.drinkImage)) { image in
                    image
                        .resizable()
                } placeholder: {
                    ProgressView()
                }
                
                HStack {
                    Text(store.cartItem.drinkName.description)
                    Spacer()
                    Text("")
                }
                
            }
        }
        
    }
    
    
    
}
