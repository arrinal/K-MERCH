//
//  Item.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 22/10/21.
//

import Foundation

struct Item: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let image: String
    let price: Int
    let category: String
    let description: String
    let isFeatured: Bool
    let isBestSeller: Bool
    
    
    init(id: Int = 0, name: String = "", image: String = "", price: Int = 0, category: String = "" , description: String = "", isFeatured: Bool = false, isBestSeller: Bool = false) {
        self.id = id
        self.name = name
        self.image = image
        self.price = price
        self.category = category
        self.description = description
        self.isFeatured = isFeatured
        self.isBestSeller = isBestSeller
    }
}
