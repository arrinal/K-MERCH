//
//  CartView.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 04/11/21.
//

import SwiftUI
import SwURL

struct CartView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var isNavigateToCheckout = false
    @State var isShowingAlert = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Shopping Cart")
                    .font(.title)
                    .bold()
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("K-MERCH")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.blue)
                }
            }
            .background(
                NavigationLink(destination: CheckoutShippingView(), isActive: $isNavigateToCheckout) {
                    EmptyView()
                }
            )
            
            if viewModel.totalItems != 0 {
                ScrollView {
                    ForEach($viewModel.cart.insideCart.indices) { index in
                        if viewModel.cart.insideCart[index].quantity >= 1 {
                            Divider()
                                HStack {
                                    AsyncImage(url: URL(string: viewModel.cart.insideCart[index].item.image)!, placeholder: { Image("not-found").resizable().aspectRatio(contentMode: .fit).frame(width: 100, height: 100).cornerRadius(10) })
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(10)
                                    VStack(alignment: .leading) {
                                        Text(viewModel.cart.insideCart[index].item.name)
                                            .padding(.top, 5)
                                        Text("\(viewModel.cart.insideCart[index].item.category)")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text("\(viewModel.cart.insideCart[index].item.price)")
                                            .padding(.top, 1)
                                    }
                                    Spacer()
                                    
                                    HStack {
                                        Button {
                                            viewModel.removeItemFromCart(index: index)
                                            viewModel.subtractItemQuantity(index: index)
                                        } label: {
                                            Image(systemName: "minus.circle")
                                        }
                                        
                                        Text("\(viewModel.cart.insideCart[index].quantity)")
                                        
                                        Button {
                                            viewModel.addItemQuantity(index: index)
                                        } label: {
                                            Image(systemName: "plus.circle")
                                        }
                                    }
                                    
                                }
                        }
                        
                    }
                    Divider()
                }
                
                Spacer()
                
                HStack {
                    Text("Subtotal \(viewModel.totalItems) items")
                    Spacer()
                    Text("\(viewModel.cart.subTotal)")
                        .font(.title2)
                }
                
                HStack {
                    Text("Proceed to Checkout")
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(20)
                .onTapGesture {
                    guard viewModel.totalItems >= 1 else { return }
                    isNavigateToCheckout = true
                    viewModel.totalPrice(deliveryPrice: 0)
                }
                .padding(.top)
            } else {
                Spacer()
                Text("Your shopping cart still empty")
                    .bold()
                Image("not-found")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                Spacer()
            }
        }
        .padding(.top, -20)
        .padding(.leading)
        .padding(.trailing)
        .padding(.bottom)
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
            .environmentObject(ViewModel())
    }
}
