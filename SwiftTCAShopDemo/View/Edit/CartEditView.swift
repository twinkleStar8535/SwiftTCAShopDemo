//
//  CartEditView.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/26.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct CartEditView: View {
    
    @Bindable var store: StoreOf<CartEditDomain>

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 2) {
                    Rectangle()
                        .fill(.clear)
                        .aspectRatio(CGFloat(17) / 9, contentMode: .fit)
                        .overlay {
                            KFImage(URL(string: store.cartEditItem.drinkImage)!)
                                .placeholder { ProgressView() }
                                .resizable()
                                .scaledToFit()
                        }
                        .clipped()
                    
                    HStack {
                        Text(store.cartEditItem.drinkName)
                            .font(Font.custom("jf-openhuninn-2.1", size: 24))
                            .foregroundStyle(.sub)
                            .frame(alignment: .center)
                            .padding(.leading)
                        
                        Spacer()
                        
                        makePriceText(store: store, .sub)
                    }
                    
                    HStack {
                        Text("姓名:")
                            .font(Font.custom("jf-openhuninn-2.1", size: 18))
                            .foregroundStyle(.white)
                            .padding(.top)
                            .padding(.horizontal)
                        
                        TextField(" 輸入你的名字", text: $store.cartEditItem.userName.sending(\.setUserName))
                            .frame(width: .none, height: 55)
                            .font(.system(size: 20, weight: .regular))
                            .padding(.top)
                            .padding(.horizontal)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    HStack {
                        Text("杯數")
                            .font(Font.custom("jf-openhuninn-2.1", size: 18))
                            .foregroundStyle(.white)
                        Spacer()
                        AddToCartButton(store: store) {
                            store.send(.addCountWhenTapped)
                        } minusAction: {
                            store.send(.minusCountWhenTapped)
                        }
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    
                    SizeMenu(store: store)
                    
                    IceMenu(store: store)
                    
                    SugarMenu(store: store)
                    
                    HStack {
                        Text("總價:")
                            .font(Font.custom("jf-openhuninn-2.1", size: 20))
                            .foregroundStyle(.white)
                        Spacer()
                        Text("NT$ \(store.totalPrice)")
                            .font(Font.custom("jf-openhuninn-2.1", size: 20))
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(.sub.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                }
            }
            .frame(maxHeight: .infinity)

            VStack(alignment: .leading) {
                Text("確認品項為:\(store.cartEditItem.drinkName)\n甜度:\(store.cartEditItem.sugarUnit.rawValue),溫度:\(store.cartEditItem.tempUnit.rawValue),大小:\(store.cartEditItem.size.rawValue) \n購買人：\(store.cartEditItem.userName)")
                    .foregroundStyle(.white)
                    .padding(25)
                Button(
                    action: {
                        store.send(.saveButtonTapped)
                    },
                    label: {
                        HStack {
                            Image(uiImage: UIImage(named: "desk")!)
                            Text("加入購物車")
                                .foregroundStyle(.white)
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(.sub)
                    }
                )
            }
            .frame(maxWidth: .infinity)
            .background(.main.shadow(.inner(color: .black.opacity(0.6), radius: 10)))
        }
        .background(.main)
    }
    
    @ViewBuilder
    func makePriceText(store: StoreOf<CartEditDomain>, _ color: Color) -> some View {
        Text("\(store.cartEditItem.size.rawValue) NT$:\(store.cartEditItem.price)")
            .font(Font.custom("jf-openhuninn-2.1", size: 18))
            .foregroundStyle(color)
            .padding(.trailing)
    }
}

#Preview {
    CartEditView(store: .init(initialState: CartEditDomain.State.previewState(), reducer: {
        CartEditDomain()
    }))
}
