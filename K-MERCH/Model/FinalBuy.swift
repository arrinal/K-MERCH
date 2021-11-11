//
//  FinalBuy.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 08/11/21.
//

import Foundation

struct FinalBuy {
    var items = Cart()
    var shippingAddress = ShippingAddress()
    var delivery = Delivery()
    var totalPrice = Int()
    var paymentMethod = String()
}
