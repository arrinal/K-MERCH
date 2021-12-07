//
//  CheckoutReviewView.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 17/11/21.
//

import SwiftUI

struct CheckoutReviewView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var isNavigateToThankYou = false
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Shipping")
                    .font(.caption2)
                    .foregroundColor(.gray)
                VStack {
                    Divider()
                }
                Text("Payment")
                    .font(.caption2)
                    .foregroundColor(.gray)
                VStack {
                    Divider()
                }
                Text("Review")
                    .font(.caption2)
                    .bold()
            }
            
            ScrollView {
                HStack {
                    Text("Review")
                        .font(.title)
                        .bold()
                    Spacer()
                }
                .padding(.top)
                
                ForEach($viewModel.finalBuy.items.insideCart.indices, id:\.self) { index in
                    if viewModel.finalBuy.items.insideCart[index].quantity >= 1 {
                        Divider()
                        HStack {
                            AsyncImage(url: URL(string: viewModel.finalBuy.items.insideCart[index].item.image)!, placeholder: { Image("not-found").resizable().aspectRatio(contentMode: .fit).frame(width: 100, height: 100).cornerRadius(10) })
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                            VStack(alignment: .leading) {
                                Text("\(viewModel.finalBuy.items.insideCart[index].item.name)")
                                    .padding(.top, 5)
                                Text("\(viewModel.finalBuy.items.insideCart[index].item.category)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(viewModel.finalBuy.items.insideCart[index].item.price)")
                                    .padding(.top, 1)
                            }
                            Spacer()
                            
                            HStack {
                                Text("\(viewModel.cart.insideCart[index].quantity)")
                            }
                        }
                    }
                    
                }
                Divider()
                
                VStack {
                    HStack {
                        Text("Shipping Address")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                    
                    Divider()
                    HStack {
                        VStack(alignment: .leading) {
                            Text(viewModel.finalBuy.shippingAddress.fullName)
                                .multilineTextAlignment(.leading)
                            Text(viewModel.finalBuy.shippingAddress.street)
                                .multilineTextAlignment(.leading)
                            Text("\(viewModel.finalBuy.shippingAddress.district), \(viewModel.finalBuy.shippingAddress.city)")
                                .multilineTextAlignment(.leading)
                            Text("\(viewModel.finalBuy.shippingAddress.province), \(viewModel.finalBuy.shippingAddress.postalCode)")
                                .multilineTextAlignment(.leading)
                            Text(viewModel.finalBuy.shippingAddress.mobileNumber)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                    }
                    Divider()
                }
                .padding(.top)
                
                VStack {
                    HStack {
                        Text("Payment Method")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                    
                    Divider()
                    HStack {
                        Image("bca")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 0, maxWidth: 100)
                        Text("Bank Central Asia")
                        Spacer()
                    }
                    Divider()
                }
                .padding(.top)
                
                
            }
            .padding(.top)
            
            Spacer()
            
            VStack {
                HStack {
                    Text("Subtotal \(viewModel.totalItems) items")
                    Spacer()
                    Text("\(viewModel.cart.subTotal)")
                        .font(.title2)
                }
                HStack {
                    Text("Delivery")
                    Spacer()
                    Text("\(viewModel.finalBuy.delivery.price)")
                        .font(.title2)
                }
                HStack {
                    Text("Total")
                        .bold()
                    Spacer()
                    Text("\(viewModel.finalBuy.totalPrice)")
                        .font(.title2)
                        .bold()
                }
            }
            Button {
                viewModel.orderPlaced = OrderPlaced(id: 10001, orderInfo: viewModel.finalBuy)
                viewModel.orderList += [viewModel.orderPlaced]
                                isNavigateToThankYou = true
            } label: {
                HStack {
                    Text("Submit")
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(20)
            }
            .padding(.top)
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("K-MERCH")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.blue)
                }
            }
                                        .background(
                                            NavigationLink(destination: CheckoutThankYouView(), isActive: $isNavigateToThankYou) {
                                                EmptyView()
                                            }
                                        )
        }
        .padding(.top, -20)
        .padding(.leading)
        .padding(.trailing)
        .padding(.bottom)
        .onAppear {
            print(viewModel.finalBuy.shippingAddress)
            print(viewModel.finalBuy.totalPrice)
            print(viewModel.finalBuy.delivery)
            print(viewModel.finalBuy.items)
            print(viewModel.finalBuy.paymentMethod)
        }
    }
}

struct CheckoutReviewView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutReviewView()
            .environmentObject(ViewModel())
    }
}
