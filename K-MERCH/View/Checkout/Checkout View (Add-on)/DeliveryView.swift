//
//  DeliveryView.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 08/11/21.
//

import SwiftUI

struct DeliveryView: View {
    
    var service: String
    var estimate: String
    var price: Int
    var delivery: Delivery
    @Binding var selectedDelivery: Delivery
    
    
    var body: some View {
        HStack {
            Image("jne")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 0, maxWidth: 100)
            Spacer()
            VStack {
                Text("\(price)")
                    .bold()
                    .padding(.bottom, 1)
                
                Text("JNE \(service)")
                    .bold()
                Text("\(estimate) days")
                    .bold()
                    .font(.caption)
            }
            Spacer()
            Spacer()
            Image(systemName: self.selectedDelivery == delivery ? "circle.inset.filled" : "circle")
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

//struct DeliveryView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeliveryView(service: "OKE", estimate: "2-4", price: 27000, isChoosed: true)
//    }
//}
