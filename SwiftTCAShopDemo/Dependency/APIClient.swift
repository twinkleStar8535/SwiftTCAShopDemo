//
//  APIClient.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/22.
//

import Foundation
import ComposableArchitecture


struct APIClient {
    // Fetch from Github Mock JSOn
    
    var getAllDrinkFromCatrgory:@Sendable () async throws -> [ProductCategory]
    
    // CRUD for Order => Airtable
    
   //  var getAllDrinkFromCart:@Sendable () async throws -> [CartItem]
   //  var addDrinkToCart:@Sendable () async throws -> [CartItem]
   //  var editDrinkFromCart:@Sendable (CartItem) async throws -> [CartItem]
   //  var deleteDrinkFromCart:@Sendable (CartItem) async throws -> [CartItem]
}

extension DependencyValues {
    var apiClient:APIClient {
        get {self[APIClient.self]}
        set {self[APIClient.self] = newValue}
    }
}

extension APIClient:DependencyKey {
    static let liveValue: APIClient = APIClient {
        
        do {
            let (data,respsone) = try await URLSession.shared.data(from: URL(string: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/drink.json")!)
            
            guard let responseStatus = (respsone as? HTTPURLResponse)?.statusCode,
                  (200..<300).contains(responseStatus) else {
                throw NetworkError.responseError
            }
            
            guard let fullCategory = try? JSONDecoder().decode([ProductCategory].self, from: data) else {
                throw NetworkError.decodeError
            }
            
            return fullCategory
        } catch {
            throw NetworkError.downloadError
        }
    }
}



/*
 import Foundation
 import ComposableArchitecture

 struct APIClient {
     var getFullDrinkWithCategory: @Sendable () async throws -> ([ProductCategory])
 //    var getDrinkByCategory: @Sendable (String) async throws -> ([Product])
     var sendFullOrder:  @Sendable ([Cart]) async throws -> String
     var editOrder: @Sendable ([Cart]) async throws -> String
     var deleteOrder: @Sendable ([Cart]) async throws -> String
 }

 //struct CartRecords: Codable {
 //    let records: [CartRecord]
 //}
 //
 //struct CartRecord: Codable {
 //    let fields: Cart
 //}
 //
 //struct Cart: Codable {
 //    var id: String
 //    var size: String
 //    var sugarUnit: String
 //    var drinkName: String
 //    var name: String
 //    var ice: String
 //    var prices: String
 //    var count: String
 //}

 extension APIClient:DependencyKey {
     
     static var liveValue: APIClient {
         APIClient(getFullDrinkWithCategory: {
             
             do{
                 let (data,_) = try await URLSession.shared.data(from: URL(string: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/drink.json")!)
                 
                 guard let fullProductData = try? JSONDecoder().decode([ProductCategory].self, from: data) else {
                     throw NetworkError.decodeError
                 }
                 
                 
                 return fullProductData
                 
             } catch {
                 print("Can't fetch Drink List \(error)")
                 throw NetworkError.downloadError
             }
             
         }, sendFullOrder: { _ in
             var sendOrderRequest = URLRequest(url: URL(string: "")!)
             sendOrderRequest.httpMethod = "POST"
             sendOrderRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
             
             
             return ""
             
         },editOrder: { _ in
             var editOrderRequest = URLRequest(url: URL(string: "")!)
             editOrderRequest.httpMethod = "PATCH"
             editOrderRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
             
             return ""
         },deleteOrder: { _ in
             var deleteOrderRequest = URLRequest(url: URL(string: "")!)
             deleteOrderRequest.httpMethod = "DELETE"
             deleteOrderRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
             return ""
         })
     }
     
 }

 extension DependencyValues {
     var apiClient:APIClient {
         get { self[APIClient.self] }
         set { self[APIClient.self] = newValue }
     }
 }


 /*
  getFullCategory: {
      do{
          var category:[String] = []
          
          let (data,_) = try await URLSession.shared.data(from: URL(string: "https://raw.githubusercontent.com/twinkleStar8535/drinkMockData/main/drink.json")!)
          
          guard let fullProductData = try? JSONDecoder().decode([ProductCategory].self, from: data) else {
              throw NetworkError.decodeError
          }
          
          for productData in fullProductData {
              category.append(productData.category)
          }
          
          return category
      } catch {
          print("Can't fetch Drink List \(error)")
          throw NetworkError.downloadError
      }
        
  }
  
  var getDrinkByCategory: @Sendable (String) async throws -> ([Product])

  */

 */
