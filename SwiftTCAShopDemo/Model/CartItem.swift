//
//  CartItem.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/22.
//

import Foundation

enum SizeUnit:String,Codable,CaseIterable{
   case M = "中杯"
   case L = "大杯"
}


enum SugarUnit:String,Codable,CaseIterable{
    case noSugar  = "無糖"
    case oneUnitSugar = "一分糖"
    case lessSugar = "微糖"
    case dropSomeSUgar = "少糖"
    case halfSugar = "半糖"
    case fullSugar = "正常糖"
}


enum TempUnit:String,Codable,CaseIterable{
    case noIce = "去冰"
    case lessIce = "少冰"
    case normalIce = "正常冰"
    case lukeWarm = "溫"
    case hot = "熱"
}


struct CartRecords: Codable {
    let records: [CartRecord]
}

struct CartRecord: Codable {
    let fields: CartItem
}

struct CartItem: Codable, Equatable, Identifiable {
    var id: UUID
    var drinkImage: String
    var drinkName: String
    var userName: String
    var size: SizeUnit
    var sugarUnit: SugarUnit
    var tempUnit: TempUnit
    var price: Int   
    var quantity: Int
    
    var soldMPrice: Int?
    var soldLPrice: Int? 
}

extension CartItem {
    enum CartItemsKey: String, CodingKey {
        case id
        case drinkImage
        case drinkName
        case userName
        case size
        case sugarUnit
        case tempUnit
        case price
        case quantity
    }
   
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CartItemsKey.self)
        try container.encode(id, forKey: .id)
        try container.encode(drinkImage, forKey: .drinkImage)
        try container.encode(drinkName, forKey: .drinkName)
        try container.encode(userName, forKey: .userName)
        try container.encode(size, forKey: .size)
        try container.encode(sugarUnit, forKey: .sugarUnit)
        try container.encode(tempUnit, forKey: .tempUnit)
        try container.encode(price, forKey: .price)
        try container.encode(quantity, forKey: .quantity)
    }
    
}


extension CartItem  {
    static func previewState() -> [CartItem] {
        let items = [
        CartItem(
            id: UUID(),
            drinkImage: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/焙香大麥拿鐵.png",
            drinkName: "焙香大麥拿鐵",
            userName: "ABC",
            size: .M,
            sugarUnit: .halfSugar,
            tempUnit: .lessIce,
            price: 50,
            quantity: 1
        ),
        CartItem(
            id: UUID(),
            drinkImage: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/輕纖蕎麥拿鐵.png",
            drinkName: "輕纖蕎麥拿鐵",
            userName: "DEF",
            size: .L,
            sugarUnit: .halfSugar,
           tempUnit: .lessIce,
           price: 60,
          quantity: 1)
       ]
        return items
    }
}
