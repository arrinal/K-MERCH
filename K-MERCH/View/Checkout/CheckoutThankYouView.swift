//
//  CheckoutThankYouView.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 21/11/21.
//

import SwiftUI

struct CheckoutThankYouView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(Color.green)
                .font(.largeTitle)
                Text("Thank you for your order!")
                    .font(.title)
                    .padding(.top, 5)
                Text("Your order number is #\(String(viewModel.orderPlaced.id))")
                Text("Amount to be paid:")
                    .padding(.top)
                Text("Rp. \(viewModel.orderPlaced.orderInfo.totalPrice)")
            }
            
            VStack(alignment: .leading) {
                Text("Please transfer the total amount of your order to the following bank account:")
                Text("\(viewModel.orderPlaced.orderInfo.paymentMethod) - 2347863278648 - A/N Arrinal S")
                    .padding(.top, 5)
            }
            .padding(.top, 20)
            
            Spacer()
            
            Button {
                viewModel.navigationSelection = nil
            } label: {
                HStack {
                    Text("Back to Home")
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
//                                        .background(
//                                            NavigationLink(destination: Text(""), tag: "", selection: $viewModel.selection) {
//                                                EmptyView()
//                                            }
//                                        )
        }
        .padding(.top, -100)
        .padding(.leading)
        .padding(.trailing)
        .padding(.bottom)
        .navigationBarBackButtonHidden(true)
    }
}

struct CheckoutThankYouView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutThankYouView()
            .environmentObject(ViewModel())
    }
}
