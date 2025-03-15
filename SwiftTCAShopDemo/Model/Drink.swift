//
//  Drink.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/21.
//

import Foundation

struct DrinkCategory: Equatable,Codable {
    let category: String
    let drinks: [Drink]
}

struct Drink: Equatable , Codable {
    let name: String
    let prices: DrinkPrices
    let img: String
}

extension Drink {
    enum DrinkKeys: String, CodingKey {
        case name
        case prices
        case img
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: DrinkKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.prices = try container.decode(DrinkPrices.self, forKey: .prices)
        self.img = try container.decode(String.self, forKey: .img)
    }
}

struct DrinkPrices: Codable , Equatable{
    let mPrice: Int?
    let lPrice: Int?
}

extension DrinkCategory {
    static var sample:[DrinkCategory] {
       [
        .init(category: "日本直送", drinks: [
            Drink(name: "水之森玄米抹茶", prices: DrinkPrices(mPrice: nil, lPrice: 45), img: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/水之森玄米抹茶.png"),
            Drink(name: "玄米抹茶鮮奶", prices: DrinkPrices(mPrice: 65, lPrice: 85), img: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/玄米抹茶鮮奶.png")
        ]),
        .init(category: "愛茶的牛", drinks: [
            Drink(name: "娜杯紅茶", prices: DrinkPrices(mPrice: nil, lPrice: 40), img: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/娜杯紅茶.png"),
            Drink(name: "英倫伯爵紅茶", prices: DrinkPrices(mPrice: nil, lPrice: 35), img: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/英倫伯爵紅茶.png")
        ]),
        .init(category: "無咖啡因", drinks: [
            Drink(name: "焙香大麥拿鐵", prices: DrinkPrices(mPrice: 50, lPrice: 60), img: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/焙香大麥拿鐵.png"),
            Drink(name: "輕纖蕎麥拿鐵", prices: DrinkPrices(mPrice: 60, lPrice: 70), img: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/輕纖蕎麥拿鐵.png")
        ])
       ]
    }
}
