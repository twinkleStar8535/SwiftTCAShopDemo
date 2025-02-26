//
//  Product.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/21.
//

import Foundation

struct ProductCategory: Equatable,Codable {
    let category: String
    let products: [Product]
}

struct Product: Equatable , Codable {
    let name: String
    let prices: ProductPrices
    let img: String
}

extension Product {
    enum ProductKeys: String, CodingKey {
        case name
        case prices
        case img
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: ProductKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.prices = try container.decode(ProductPrices.self, forKey: .prices)
        self.img = try container.decode(String.self, forKey: .img)
    }
}

struct ProductPrices: Codable , Equatable{
    let mPrice: Int?
    let lPrice: Int?
}

extension ProductCategory {
    static var sample:[ProductCategory] {
       [
        .init(category: "日本直送", products: [
            Product(name: "水之森玄米抹茶", prices: ProductPrices(mPrice: nil, lPrice: 45), img: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/水之森玄米抹茶.png"),
            Product(name: "玄米抹茶鮮奶", prices: ProductPrices(mPrice: 65, lPrice: 85), img: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/玄米抹茶鮮奶.png")
        ]),
        .init(category: "愛茶的牛", products: [
            Product(name: "娜杯紅茶", prices: ProductPrices(mPrice: nil, lPrice: 40), img: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/娜杯紅茶.png"),
            Product(name: "英倫伯爵紅茶", prices: ProductPrices(mPrice: nil, lPrice: 35), img: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/英倫伯爵紅茶.png")
        ]),
        .init(category: "無咖啡因", products: [
            Product(name: "焙香大麥拿鐵", prices: ProductPrices(mPrice: 50, lPrice: 60), img: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/焙香大麥拿鐵.png"),
            Product(name: "輕纖蕎麥拿鐵", prices: ProductPrices(mPrice: 60, lPrice: 70), img: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/輕纖蕎麥拿鐵.png")
        ])
       ]
    }
}
