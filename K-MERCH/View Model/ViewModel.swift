//
//  ViewModel.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 02/11/21.
//

import Foundation
import Combine
import SwiftyJSON
import SwiftUI
import CloudKit

class ViewModel: ObservableObject {
    @Published var navigationSelection: String? = nil
    @Published var items: [Item] = []
    @Published var cart = Cart()
    @Published var shippingAddress = ShippingAddress()
    @Published var provinceList = [Province]()
    @Published var cityList = [City]()
    @Published var deliveryMenu = [Delivery]()
    @Published var text = "bagong"
    @Published var finalBuy = FinalBuy()
    @Published var orderPlaced = OrderPlaced()
    @Published var orderList = [OrderPlaced]()
    @Published var paymentMethodMenu: [PaymentMethod] = [PaymentMethod(bankName: "Bank BCA", image: "bca")]
    
    
    var totalItems: Int {
        get {
            var total = 0
            for each in cart.insideCart {
                total += each.quantity
            }
            return total
        }
    }
    
    
    init() {
        fetchItemsCloudKit()
    }
    
    func fetchItemsCloudKit() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "item", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
//        queryOperation.resultsLimit = 6
        
        var returnedItems: [Item] = []
        
        if #available(iOS 15.0, *) {
            queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
                switch returnedResult {
                case .success(let record):
                    returnedItems += self.addToItemListCloudKit(list: record)
                   
                    
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            queryOperation.recordFetchedBlock = { [self] (returnedRecord) in
                returnedItems += addToItemListCloudKit(list: returnedRecord)
                
            }
        }
        
        
        if #available(iOS 15.0, *) {
            queryOperation.queryResultBlock = { [weak self] returnedResult in
                print("returned result: \(returnedResult)")
                print(returnedItems)
                DispatchQueue.main.async {
                    self?.items = returnedItems
                }
                
                
            }
        } else {
            queryOperation.queryCompletionBlock = { [weak self] (returnedCursor, returnedError) in
                print("returned querycompletionblock")
                DispatchQueue.main.async {
                    self?.items = returnedItems
                }
                
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(queryOperation)
    }
    
    func addToItemListCloudKit(list: CKRecord) -> [Item] {
        let id = list["id"] as! Int
        let name = list["name"] as! String
        let image = list["image"] as! String
        let price = list["price"] as! Int
        let category = list["category"] as! String
        let description = list["description"] as? String ?? ""
        let isFeatured = list["isFeatured"] as! Int
        let isBestSeller = list["isBestSeller"] as! Int
        let recordID = list.recordID
        
        return [Item(id: id, name: name, image: image, price: price, category: category, description: description, isFeatured: Bool(truncating: isFeatured as NSNumber), isBestSeller: Bool(truncating: isBestSeller as NSNumber), recordID: recordID)]
    }
    
    func onlyNumberAndLimitText(limit: Int, value: String, field: Binding<String>) {
        limitText(limit)
            let filtered = value.filter { "0123456789".contains($0) }
                            if filtered != value {
                                field.wrappedValue = filtered
        }
    }
    
    func updateCity(isShowCity: Binding<Bool>, city: City) {
        shippingAddress.city = "\(city.type) \(city.city)"
        fetchCost(cityId: city.id)
        isShowCity.wrappedValue.toggle()
    }
    
    func updateProvince(isShowProvince: Binding<Bool>, province: Province) {
        shippingAddress.province = province.province
        shippingAddress.city = "City"
        withAnimation {
            deliveryMenu = []
        }
        fetchCity(idProvince: province.id)
        isShowProvince.wrappedValue.toggle()
    }
    
    func subtractItemQuantity(index: Int) {
        withAnimation {
            cart.insideCart[index].quantity -= 1
        }
        cart.insideCart[index].itemPriceTotal -= Int(cart.insideCart[index].item.price)
        cart.subTotal -= Int(cart.insideCart[index].item.price)
    }
    
    func addItemQuantity(index: Int) {
        cart.insideCart[index].quantity += 1
        cart.insideCart[index].itemPriceTotal += Int(cart.insideCart[index].item.price)
        cart.subTotal += Int(cart.insideCart[index].item.price)
    }
    
    func removeItemFromCart(index: Int) {
        guard cart.insideCart[index].quantity > 0 else {
            cart.insideCart.remove(at: index)
            return
        }
    }
    
    func limitText(_ upper: Int) {
        if upper == 5 {
            if shippingAddress.postalCode.count > upper {
                shippingAddress.postalCode = String( shippingAddress.postalCode.prefix(upper))
            }
        }
        
        if upper == 13 {
            if shippingAddress.mobileNumber.count > upper {
                shippingAddress.mobileNumber = String( shippingAddress.mobileNumber.prefix(upper))
            }
        }
            
        }
    
    func totalPrice(deliveryPrice: Int) {
        finalBuy.totalPrice = deliveryPrice + cart.subTotal
    }
    
    func fetchCost(cityId: String) {
        
        let headers = [
          "key": "f11fdd575602c1fb2fd8caf47425118f",
          "content-type": "application/x-www-form-urlencoded"
        ]

        let postData = NSMutableData(data: "origin=153".data(using: String.Encoding.utf8)!)
        postData.append("&destination=\(cityId)".data(using: String.Encoding.utf8)!)
        postData.append("&weight=\(totalItems * 1000)".data(using: String.Encoding.utf8)!)
        postData.append("&courier=jne".data(using: String.Encoding.utf8)!)

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.rajaongkir.com/starter/cost")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error!)
          } else {
              DispatchQueue.main.async {
                  withAnimation {
                      self.deliveryMenu = []
                  }
              }
              if let json = try? JSON(data: data!) {
                  let rajaongkir = json["rajaongkir"]
                  for result in rajaongkir["results"] {
                      let courier = result.1["name"].stringValue
                      for cost in result.1["costs"] {
                          let service = cost.1["service"].stringValue
                          let price = cost.1["cost"][0]["value"].rawValue
                          let estimate = cost.1["cost"][0]["etd"].stringValue
                          DispatchQueue.main.async {
                              withAnimation {
                                  self.deliveryMenu += [Delivery(courier: courier, service: service, price: price as! Int, estimate: estimate)]
                              }
                              
                          }
                      }
                  }
              }
          }
        })

        dataTask.resume()
    }
    
    
    func fetchProvince() {
        let headers = ["key": "f11fdd575602c1fb2fd8caf47425118f"]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.rajaongkir.com/starter/province")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
              print(error!)
          } else {
              if let json = try? JSON(data: data!) {
                  let rajaongkir = json["rajaongkir"]
                  for result in rajaongkir["results"] {
                      let id = result.1["province_id"].stringValue
                      let province = result.1["province"].stringValue
                      
                      DispatchQueue.main.async {
                          self.provinceList += [Province(id: id, province: province)]
                      }
                  }
              }
          }
        })

        dataTask.resume()
    }
    
    func fetchCity(idProvince: String) {
        let headers = ["key": "f11fdd575602c1fb2fd8caf47425118f"]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.rajaongkir.com/starter/city?province=\(idProvince)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
              print(error!)
          } else {
              DispatchQueue.main.async {
                  self.cityList = []
              }
              if let json = try? JSON(data: data!) {
                  let rajaongkir = json["rajaongkir"]
                  for result in rajaongkir["results"] {
                      let id = result.1["city_id"].stringValue
                      let type = result.1["type"].stringValue
                      let city = result.1["city_name"].stringValue
                      let postalCode = result.1["postal_code"].stringValue
                      
                      DispatchQueue.main.async {
                          self.cityList += [City(id: id, type: type, city: city, postalCode: postalCode)]
                      }
                  }
              }
          }
        })

        dataTask.resume()
    }
}
