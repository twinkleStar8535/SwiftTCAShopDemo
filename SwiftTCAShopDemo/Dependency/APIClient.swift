//
//  APIClient.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/22.
//

import Foundation
import SwiftUI
import ComposableArchitecture


enum NetworkError:Error{
    case decodeError
    case responseError
    case downloadError
    
    case uploadError
    case deleteError
}

struct APIClient {
    // Fetch from Github Mock JSOn
    
    var getAllDrinks:@Sendable () async throws -> [DrinkCategory]
    // CRUD for Order => Airtable
    
     var sendDrinkOrder: @Sendable ([CartItem]) async throws -> ()
     var fetchDrinkOrder:@Sendable () async throws -> [CartItem]
     var deleteDrinkFromOrder:@Sendable (CartItem) async throws -> [CartItem]
}

extension DependencyValues {
    var apiClient:APIClient {
        get {self[APIClient.self]}
        set {self[APIClient.self] = newValue}
    }
}

extension APIClient:DependencyKey {
    static let liveValue: APIClient = APIClient(getAllDrinks: {
        do {
            let (data,response) = try await URLSession.shared.data(from: URL(string: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/drink.json")!)
            
            guard let responseStatus = (response as? HTTPURLResponse)?.statusCode,
                  (200..<300).contains(responseStatus) else {
                throw NetworkError.responseError
            }
            
            guard let fullCategory = try? JSONDecoder().decode([DrinkCategory].self, from: data) else {
                throw NetworkError.decodeError
            }
            
            return fullCategory
        } catch {
            print("Download Error")
            throw NetworkError.downloadError
        }
    }, sendDrinkOrder: {sendItems in
        
        
        let cartRecords = sendItems.map { CartRecord(fields: $0) }
        let cartRecordsRequest = CartRecords(records: cartRecords)
    
        let readySendItem = try JSONEncoder().encode(cartRecordsRequest)
        
        var urlRequest = URLRequest(url: URL(string: "https://api.airtable.com/v0/appMbNBmi4RxMRNIc/drinkOrder")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer pat9GXrJkAXQ1Y5Hs.62bc7af9d7cb94c00d47efdd2002d59399ecf000af06a8bdd8bf61797a37ac7f", forHTTPHeaderField: "Authorization")
        
        let (data,response) =  try await URLSession.shared.upload(for: urlRequest, from: readySendItem)
        
        print(response)
        
        guard let httpResponse = (response as? HTTPURLResponse) else {
            print("Upload Error")
            // For debugging
            if let responseData = String(data: data, encoding: .utf8) {
                print("Response: \(responseData)")
            }
            
            throw NetworkError.uploadError
        }
        
    }, fetchDrinkOrder: {
        var urlRequest = URLRequest(url: URL(string: "https://api.airtable.com/v0/appMbNBmi4RxMRNIc/drinkOrder")!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer pat9GXrJkAXQ1Y5Hs.62bc7af9d7cb94c00d47efdd2002d59399ecf000af06a8bdd8bf61797a37ac7f", forHTTPHeaderField: "Authorization")
        var cartItems:[CartItem] = []
        let (data,response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let responseStatus = (response as? HTTPURLResponse)?.statusCode,
              (200..<300).contains(responseStatus) else {
            throw NetworkError.responseError
        }
        
        guard let fullDrinkRecord = try? JSONDecoder().decode(CartRecords.self, from: data) else {
            throw NetworkError.decodeError
        }
        
        for record in fullDrinkRecord.records {
            cartItems.append(record.fields)
        }
        
        return cartItems
    }, deleteDrinkFromOrder: { deleteItem in
        var urlRequest = URLRequest(url: URL(string: "https://api.airtable.com/v0/appMbNBmi4RxMRNIc/drinkOrder/\(deleteItem.id)")!)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("Bearer pat9GXrJkAXQ1Y5Hs.62bc7af9d7cb94c00d47efdd2002d59399ecf000af06a8bdd8bf61797a37ac7f", forHTTPHeaderField: "Authorization")
        
        let (data,response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = (response as? HTTPURLResponse) else {
            print("Delete Error")
            throw NetworkError.deleteError
        }
        
        guard let fullDrinkOrder = try? JSONDecoder().decode([CartItem].self, from: data) else {
            throw NetworkError.decodeError
        }
            
        return fullDrinkOrder
        
    })
}
