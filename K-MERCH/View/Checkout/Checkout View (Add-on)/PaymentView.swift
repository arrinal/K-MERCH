//
//  PaymentView.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 09/11/21.
//

import SwiftUI

struct PaymentView: View {
    var paymentMethod: String
    var image: String
    @Binding var selectedPayment: String
    
    
    var body: some View {
        HStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 0, maxWidth: 100)
            Spacer()
            VStack {
                Text(paymentMethod)
                    .bold()
            }
            Spacer()
            Spacer()
            Image(systemName: self.selectedPayment == paymentMethod ? "circle.inset.filled" : "circle")
        }
        .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width - 100)
        .frame(height: 100)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue, lineWidth: 2)
        )
        
    }
}

//struct PaymentView_Previews: PreviewProvider {
//    static var previews: some View {
//        PaymentView()
//    }
//}
