//
//  HomeView.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/23.
//

import SwiftUI
import ComposableArchitecture

struct HomeView:View {
    @Bindable var store:StoreOf<HomeDomain>
    
    var columns = [GridItem(.flexible()),GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            VStack{
                ScrollView {
                    // 導覽列,右側點擊進入購買紀錄
                    HStack {
                        Text("Hello")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.white)
                            .padding(.leading,30)
                        
                        Spacer()
                        
                        NavigationLink {
                            // For 購買車
                            // CartListView
                        } label: {
                            HStack(){
                                Image(systemName: "basket.fill")
                                    .tint(.white)
                                    .padding(.leading, 10)
                                Text("購物車")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .padding(.trailing,5)
                            }
                            .padding()
                        }
                        
                    }
                  
                    // 分類
                    ScrollView(.horizontal,showsIndicators: false) {
                        LazyHStack(spacing:10) {
                            ForEach(store.fetchedCategory,id:\.self) { category in
                                DrinkSegment(onTap: {
                                    store.send(.selectCategory(category))
                                }, segmentTitle: category)
                            }
                            
                        }.padding(.horizontal)
                    }.frame(height:50)
                    
                    // 清單項目
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(store.productList) { each in
                            
                            Button {
                                store.send(.initializeCartBy(.presented(.loadFrom(each.product))))
                            } label: {
                                ProductCell(product: each.product)
                            }
                        }
                    }.task {
                        store.send(.startFetchDrink)
                    }.padding()
                    
                }
            }
            .background(Color("MainColor"))
        }
        .sheet(item: $store.scope(state: \.cartEditState, action: \.initializeCartBy) ) { cartEditDomain in
            NavigationStack {
                CartEditView(store: cartEditDomain)
            }
        }
          
    }
}




#Preview {
    HomeView(store: .init(initialState: HomeDomain.State(),
            reducer: {
                  HomeDomain()
    }, withDependencies: { dependency in
        dependency.apiClient.getAllDrinkFromCatrgory = {ProductCategory.sample}
    }),
             columns: [GridItem(.flexible()),GridItem(.flexible())])
}
    

