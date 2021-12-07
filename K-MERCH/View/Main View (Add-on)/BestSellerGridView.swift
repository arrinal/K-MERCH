//
//  BestSellerGridView.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 22/10/21.
//

import SwiftUI
import SwURL

struct BestSellerGridView: View {
    let name: String
    let img: String
    let price: Int
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: img)!, placeholder: { Image("not-found").resizable().aspectRatio(contentMode: .fit).cornerRadius(10) })
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
            
            HStack {
                Text("Rp. \(price)")
                Spacer()
            }
            
            HStack {
                Text(name)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                Spacer()
            }
            Spacer()
        }
        .frame(height: 300)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray)
        )
    }
}


//struct BestSellerGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        BestSellerGridView(items: [Item(id: 1, name: "Cravity Season 3 (Hideout: Be Our Voice)", image: "a", price: 290000, category: "Album", description: "blablabla", isFeatured: false, isBestSeller: true)])
//    }
//}
