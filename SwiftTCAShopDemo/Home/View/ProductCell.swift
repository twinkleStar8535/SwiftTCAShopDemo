//
//  ProductCell.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/21.
//

import SwiftUI
import ComposableArchitecture


struct ProductCell :View {
    let product:Product
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: product.img)) { image in
                image
                  .resizable()
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(height: 125)
            } placeholder: {
                ProgressView()
            }
            
            Text(product.name)
                .font(.system(size: 18.0))
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            HStack {
                switch (product.prices.mPrice, product.prices.lPrice) {
                case (nil, nil):
                    Text("此商品尚未上市")
                        .foregroundStyle(.white)
                case (nil,let l?):
                    Text("L:$\(l)")
                        .foregroundStyle(.white)
                case (let m?, nil):
                    Text("M:$\(m)")
                        .foregroundStyle(.white)
                case (let m?, let l?):
                    Text("M:$\(m)  L:$\(l)")
                        .foregroundStyle(.white)
                }
            }

        }
        .padding(20.0)
        .background(Color("MainColor"))
    }
    
}

#Preview {
    ProductCell(product: ProductCategory.sample[0].products[1])
}
