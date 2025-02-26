//
//  CartItem.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/22.
//



struct CartRecords: Codable {
    let records: [CartRecord]
}

struct CartRecord: Codable {
    let fields: CartItem
}

struct CartItem: Codable ,Equatable{
    let drinkImage:String
    let drinkName: String
    let size:String
    let userName:String
    let sugarUnit: SugarUnit
    let soldMPrice:Int?
    let soldLPrice:Int?
    let quantity:Int
}

extension CartItem {
    
    enum CartItemsKey: String, CodingKey {
        case drinkImage
        case drinkName
        case size
        case userName
        case sugarUnit
        case soldMPrice
        case soldLPrice
        case quantity
    }
   
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CartItemsKey.self)
        try container.encode(drinkImage, forKey: .drinkImage)
        try container.encode(drinkName, forKey: .drinkName)
        try container.encode(size, forKey: .size)
        try container.encode(userName, forKey: .userName)
        try container.encode(sugarUnit, forKey: .sugarUnit)
        try container.encode(soldMPrice, forKey: .soldMPrice)
        try container.encode(soldLPrice, forKey: .soldLPrice)
        try container.encode(quantity, forKey: .quantity)
        
    }
  }


enum SugarUnit:String,Codable{
    case noSugar
    case oneUnitSugar = "一分糖"
    case lessSugar = "微糖"
    case dropSomeSUgar = "少糖"
    case halfSugar = "半糖"
    case fullSugar = "正常糖"
}
