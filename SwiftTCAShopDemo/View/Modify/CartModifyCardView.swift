//
//  CartModifyCardView.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/3/1.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct CartModifyCardView: View {
    var item: CartItemDomain.State
    var onIncrement: () -> Void
    var onDecrement: () -> Void
    var onSugarChange: (SugarUnit) -> Void
    var onTempChange: (TempUnit) -> Void
    var onSizeChange: (SizeUnit, Int) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                KFImage(URL(string: item.cartItem.drinkImage)!)
                    .placeholder { Color.gray.opacity(0.3) }
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 90)
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(item.cartItem.drinkName)
                            .font(Font.custom("jf-openhuninn-2.1", size: 16))
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Text("用戶: \(item.cartItem.userName)")
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button(action: onIncrement) {
                            Image(systemName: "plus")
                                .font(.system(size: 14))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 30, height: 30)
                        .background(Color("SubColor"))
                        .cornerRadius(8)
                        
                        Text("\(item.cartItem.quantity)")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                            .frame(width: 30, height: 30)
                        
                        Button(action: onDecrement) {
                            Image(systemName: "minus")
                                .font(.system(size: 14))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 30, height: 30)
                        .background(Color("SubColor"))
                        .cornerRadius(8)
                    }
                    
                    HStack {
                        Text("大小:")
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.7))
                        
                        Menu {
                            if let mPrice = item.cartItem.soldMPrice {
                                Button {
                                    onSizeChange(.M, mPrice)
                            } label: {
                                Text(SizeUnit.M.rawValue)
                                    .font(Font.custom("jf-openhuninn-2.1", size: 18))
                                    .opacity(item.cartItem.soldMPrice == nil ? 0.5 : 1)
                            }
                        }
                            
                            if let lPrice = item.cartItem.soldLPrice {
                                Button {
                                    onSizeChange(.L, lPrice)
                                } label: {
                                    Text(SizeUnit.L.rawValue)
                                        .font(Font.custom("jf-openhuninn-2.1", size: 18))
                                        .opacity(item.cartItem.soldLPrice == nil ? 0.5 : 1)
                                }
                                
                            }
                            
                        } label: {
                            HStack {
                                Text("\(item.cartItem.size.rawValue)")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white.opacity(0.7))
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("糖度:")
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.7))
                        
                        Menu {
                            ForEach(SugarUnit.allCases, id: \.self) { sugar in
                                Button {
                                    onSugarChange(sugar)
                                } label: {
                                    Text(sugar.rawValue)
                                        .font(Font.custom("jf-openhuninn-2.1", size: 18))
                                }
                            }
                        } label: {
                            HStack {
                                Text("\(item.cartItem.sugarUnit.rawValue)")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white.opacity(0.7))
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                        }
                        
                        Spacer()
                        
                        Text("溫度:")
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.7))
                        
                        Menu {
                            ForEach(TempUnit.allCases, id: \.self) { temp in
                                Button {
                                    onTempChange(temp)
                                } label: {
                                    Text(temp.rawValue)
                                        .font(Font.custom("jf-openhuninn-2.1", size: 18))
                                }
                            }
                        } label: {
                            HStack {
                                Text("\(item.cartItem.tempUnit.rawValue)")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white.opacity(0.7))
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Text("NT$ \(item.cartItem.price * item.cartItem.quantity)")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            .padding(.top, 4)
                    }
                }
            }
            .padding(16)
            .background(Color("CardColor"))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}
