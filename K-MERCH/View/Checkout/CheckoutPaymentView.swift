//
//  CheckoutPaymentView.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 08/11/21.
//

import SwiftUI

struct CheckoutPaymentView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State var selectedPayment = ""
    @State var isNavigateToReview = false
    
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
                    .bold()
                VStack {
                    Divider()
                }
                Text("Review")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            ScrollView {
                HStack {
                    Text("Choose Payment Method")
                        .font(.title)
                        .bold()
                    Spacer()
                }
                .padding(.top)
                
                ForEach($viewModel.paymentMethodMenu, id: \.self) { $each in
                    PaymentView(paymentMethod: each.bankName, image: each.image, selectedPayment: $selectedPayment)
//                        .padding(.top)
                        .onTapGesture {
                            selectedPayment = each.bankName
                        }
                }
                
                
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
                viewModel.finalBuy.paymentMethod = selectedPayment
                guard viewModel.finalBuy.paymentMethod != "" else { return }
                isNavigateToReview = true
            } label: {
                HStack {
                    Text("Next")
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
                                NavigationLink(destination: CheckoutReviewView(), isActive: $isNavigateToReview) {
                                    EmptyView()
                                }
                            )
        }
        .padding(.top, -20)
        .padding(.leading)
        .padding(.trailing)
        .padding(.bottom)
    }
}

struct CheckoutPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutPaymentView()
            .environmentObject(ViewModel())
    }
}
