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

class ViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var cart = Cart()
    @Published var shippingAddress = ShippingAddress()
    @Published var provinceList = [Province]()
    @Published var cityList = [City]()
    @Published var deliveryMenu = [Delivery]()
    @Published var text = ""
    @Published var finalBuy = FinalBuy()
    @Published var paymentMethodMenu: [PaymentMethod] = [PaymentMethod(bankName: "Bank BCA", image: "bca")]
    
    var cancellables = Set<AnyCancellable>()
    
    
    var totalItems: Int {
        get {
            var total = 0
            for each in cart.insideCart {
                total += each.quantity
            }
            return total
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
    
    func getItems() {
        guard let url = URL(string: "https://arrinal.com/kmerchd.php") else { return }
        
///         1. Create the publisher
///         2. Subscribe publisher on background thread
///         3. Receive on main thread
///         4. tryMap (check that the data is good)
///         5. Decode (decode data into Item)
///         6. Sink (put the item into the app)
///         7. Store (cancel subscription if needed)
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                          throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Item].self, decoder: JSONDecoder())
            .sink { (completion) in
                print("COMPLETION: \(completion)")
            } receiveValue: { [weak self] (returnedItems) in
                self?.items = returnedItems
            }
            .store(in: &cancellables)

        
    }
    
    
    func fetchCost(cityId: String) {
        
        let headers = [
          "key": "f11fdd575602c1fb2fd8caf47425118f",
          "content-type": "application/x-www-form-urlencoded"
        ]

        let postData = NSMutableData(data: "origin=153".data(using: String.Encoding.utf8)!)
        postData.append("&destination=\(cityId)".data(using: String.Encoding.utf8)!)
        postData.append("&weight=1000".data(using: String.Encoding.utf8)!)
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
    
//    func addToCart(item: Item) {
//        if let index = cart.insideCart.firstIndex(where: { $0.item == item }) {
//            cart.insideCart[index].quantity += 1
//            cart.insideCart[index].itemPriceTotal += item.price
//            cart.subTotal += item.price
//        } else {
//            cart.insideCart += [InsideCart(item: item, quantity: 1, itemPriceTotal: item.price)]
//            cart.subTotal += item.price
//        }
//
//    }
}
