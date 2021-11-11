//
//  InsideCart.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 04/11/21.
//

import SwiftUI

struct InsideCart: Hashable, Identifiable {
    ///Item and quantity
    let id = UUID()
    var item: Item
    var quantity: Int
    var itemPriceTotal: Int
    var offset: CGFloat = 0
    
    init(item: Item = Item(), quantity: Int = 0, itemPriceTotal: Int) {
        self.item = item
        self.quantity = quantity
        self.itemPriceTotal = itemPriceTotal
    }
}
