//
//  ProductCell.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/21.
//

import SwiftUI
import ComposableArchitecture

struct ProductCell:View {
    let store:StoreOf<ProductDomain>
    
    var body: some View {
        
        VStack{
            AsyncImage(url:URL(string: store.product.imageLink.url)!) { image in
                image
                    .resizable()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
            } placeholder: {
                ProgressView()
                    .frame(height: 300)
            }

            
            VStack(spacing: 20){
                Text(store.product.name)
                
                HStack{
                    
                    if (store.product.mPrice != nil &&  store.product.lPrice != nil) {
                        if let mPrice = store.product.mPrice,
                           let lPrice = store.product.lPrice {
                            Text("M: $\(mPrice) ,L: $\(lPrice)")
                                .font(.system(size: 23))
                        }
                    } else if (store.product.mPrice != nil && store.product.lPrice == nil) {
                        
                        if let mPrice = store.product.mPrice {
                            Text("M: $\(mPrice)")
                                .font(.system(size: 23))
                        }
                        
                    } else if (store.product.mPrice == nil && store.product.lPrice != nil) {
                        if let lPrice = store.product.lPrice {
                            Text("L: $\(lPrice)")
                                .font(.system(size: 23))
                        }
                    }
                    
                    Spacer()
              
                    AddToCartButton(store:
                                      self.store.scope(state: \.addToCartState,
                                           action: \.changeCartAction)
                                   )
                
                }
            }
            
            
        }.padding(20)
    }
    
}


#Preview {
    ProductCell(store: .init(initialState: ProductDomain.State(id: UUID(), product: ProductRecords.sample[0]),   reducer: {
        ProductDomain()
       })
    )
}
