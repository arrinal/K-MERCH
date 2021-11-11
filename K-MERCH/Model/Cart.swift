//
//  Cart.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 04/11/21.
//

import Foundation


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
            insideCart[index].itemPriceTotal += item.price
            subTotal += item.price
        } else {
            insideCart += [InsideCart(item: item, quantity: 1, itemPriceTotal: item.price)]
            subTotal += item.price
        }

    }
}
