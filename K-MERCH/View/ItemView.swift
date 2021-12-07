//
//  ItemView.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 03/11/21.
//

import SwiftUI
import SwURL

struct ItemView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var isNavigateToCart = false
    @State var isAddedToCart = false
    var item: Item
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Divider()
            HStack {
                Spacer()
                Divider()
                AsyncImage(url: URL(string: item.image)!, placeholder: { Image("not-found").resizable().aspectRatio(contentMode: .fit).frame(width: 200, height: 200).cornerRadius(10) })
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .cornerRadius(10)
                Divider()
                Spacer()
            }
            Divider()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("\(item.price)")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    if item.isBestSeller {
                        Text("Best Seller")
                            .font(.footnote)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.red, lineWidth: 2)
                            )
                    }
                    Text(item.category)
                        .font(.footnote)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.blue, lineWidth: 2)
                        )
                }
                
                Text(item.name)
                    .font(.headline).bold()
                
            }
            .padding(.top)
            
            VStack(alignment: .leading) {
                Text("Description")
                    .bold()
                    .padding(.bottom, 5)
                ScrollView {
                    Text(item.description)
                }
            }
            .padding(.top)
            
            Spacer()
            
            Button {
                viewModel.cart.addToCart(item: item)
                withAnimation {
                    isAddedToCart.toggle()
                }
            } label: {
                ZStack {
                    HStack {
                        Image(systemName: "cart")
                        Text("Add to cart")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(20)
                    
                    TemporaryPopUp(isActive: $isAddedToCart, text: "Added to cart.")
                        .offset(y: -70)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation {
                                    self.isAddedToCart.toggle()
                                }
                            }
                        }
                }
                
            }
            .padding(.top)
        }
        .padding(.top, -20)
        .padding(.leading)
        .padding(.trailing)
        .padding(.bottom)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("K-MERCH")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.blue)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "cart.fill")
                    .onTapGesture {
                        isNavigateToCart = true
                    }
                
            }
        }
        
        .background(
            NavigationLink(destination: CartView(), isActive: $isNavigateToCart) {
                EmptyView()
            }
        )
    }
}

//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView(item: Item(id: 1, name: "BTS Love Yourself (Tear)", image: "https://arrinal.com/kmerchImg/a.jpeg", price: 290000, category: "Album", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", isFeatured: false, isBestSeller: true))
//    }
//}
