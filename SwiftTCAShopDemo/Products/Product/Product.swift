//
//  Product.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/21.
//

import Foundation


struct ProductRecords: Codable {
    let fields: [Product]
}

struct Product: Equatable, Identifiable , Codable {
    let id:String
    let name: String
    let mPrice: Int?
    let lPrice: Int?
    let imageLink:ProductPictures
    let category: String
}

extension Product {
    enum ProductKeys: String, CodingKey {
        case id
        case name
        case mPrice
        case lPrice
        case imageLink
        case category
    }
    
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: ProductKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.mPrice = try container.decode(Int.self, forKey: .mPrice)
        self.lPrice = try container.decode(Int.self, forKey: .lPrice)
        self.imageLink = try container.decode(ProductPictures.self, forKey: .imageLink)
        self.category = try container.decode(String.self, forKey: .category)
    }
}

struct ProductPictures:Codable,Equatable{
    let url:String
    let width:Int
    let height:Int

}

extension ProductPictures {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(String.self, forKey: .url)
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
    }
}

extension ProductRecords {
    static var sample: [Product] {
        [
            .init(id: "ankfd32skl", name: "英倫伯爵紅茶", mPrice: nil, lPrice: 35,
                  imageLink:.init(url: "https://www.milksha.com/includes/timthumb.php?src=upload/product/2208260929220000001.png&w=307&zc=2", width: 307, height: 503) ,
                  category: "A-愛茶的牛"),
            .init(id: "ndrs04kbfg",name: "輕纖蕎麥拿鐵", mPrice: 60, lPrice: 70,
                  imageLink:.init(url: "https://www.milksha.com/includes/timthumb.php?src=upload/product/2406061834170000001.png&w=307&zc=2", width: 307, height: 503) ,
                  category: "B-無咖啡因"),
            .init(id: "l4bps3ple",name: "冬瓜青茶", mPrice: nil, lPrice: 50,
                  imageLink:.init(url: "https://www.milksha.com/includes/timthumb.php?src=upload/product/2208261040260000001.png&w=307&zc=2", width: 307, height: 503) ,
                  category: "D-手作特調")
        ]
    }

}



