//
//  Cart.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 04/11/21.
//

import SwiftUI
import CloudKit


struct Cart {
    var insideCart: [InsideCart]
    var subTotal: Int
    
    init(insideCart: [InsideCart] = [], subTotal: Int = 0) {
        self.insideCart = insideCart
        self.subTotal = subTotal
    }
    
    mutating func addToCart(item: Item) {
        if let index = insideCart.firstIndex(where: { $0.item == item }) {
            insideCart[index].quantity += 1
            insideCart[index].itemPriceTotal += Int(item.price)
            subTotal += Int(item.price)
        } else {
            insideCart += [InsideCart(item: item, quantity: 1, itemPriceTotal: Int(item.price))]
            subTotal += Int(item.price)
            let prepareAddToCart = CKRecord(recordType: "EachItemInCart")
            let listReference = CKRecord.Reference(recordID: item.recordID!, action: .deleteSelf)
            prepareAddToCart["id"] = 1
            prepareAddToCart["item"] = listReference
            prepareAddToCart["quantity"] = 1
            prepareAddToCart["itemPriceTotal"] = item.price
            
            CKContainer.default().publicCloudDatabase.save(prepareAddToCart) { returnedRecord, returnedError in
                print("record: \(returnedRecord)")
                print("error: \(returnedError)")
            }
        }

    }
}

struct InsideCart: Hashable, Identifiable {
    ///Item and quantity
    let id = UUID()
    var item: Item
    var quantity: Int
    var itemPriceTotal: Int
//    var offset: CGFloat = 0
    
    init(item: Item = Item(), quantity: Int = 0, itemPriceTotal: Int) {
        self.item = item
        self.quantity = quantity
        self.itemPriceTotal = itemPriceTotal
    }
}
