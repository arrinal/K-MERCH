//
//  BestSellerGridView.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 22/10/21.
//

import SwiftUI
import SwURL

struct BestSellerGridView: View {
    
    let layout = [
        GridItem(.flexible(minimum: 170)),
        GridItem(.flexible(minimum: 170))
    ]
    
    let items: [Item]
    
    
    //    ForEach(viewModel.items) { item in
    //        if item.isFeatured {
    //            NavigationLink {
    //                ItemView(item: item)
    //            } label: {
    //                ImageCardView(img: item.image , title: item.name)
    //            }
    //
    //        }
    //    }
    
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout) {
                ForEach(items, id:\.self) { item in
                    if item.isBestSeller {
                        NavigationLink {
                            ItemView(item: item)
                        } label: {
                            VStack {
                                RemoteImageView(url: URL(string: item.image)!).imageProcessing({ image in
                                    return image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                })
                                    .cornerRadius(10)
                                
                                HStack {
                                    Text("Rp. \(item.price)")
                                    Spacer()
                                }
                                
                                HStack {
                                    Text(item.name)
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
                }
            }
        }
    }
}


struct BestSellerGridView_Previews: PreviewProvider {
    static var previews: some View {
        BestSellerGridView(items: [Item(id: 1, name: "Cravity Season 3 (Hideout: Be Our Voice)", image: "a", price: 290000, category: "Album", description: "blablabla", isFeatured: false, isBestSeller: true)])
    }
}
