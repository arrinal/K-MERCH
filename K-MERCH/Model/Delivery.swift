//
//  Delivery.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 08/11/21.
//

import Foundation

struct Delivery: Hashable {
    var courier: String = ""
    var service: String = ""
    var price: Int = 0
    var estimate: String = ""
    var isChoosed: Bool = false
}
