//
//  CardView.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 20/10/21.
//

import SwiftUI

struct CardView: View {
    var text: String
    var backgroundColor: Color
    
    var body: some View {
        VStack {
            Text(text.uppercased())
            
                .font(.system(size: 18))
                .bold()
                .frame(width: 200, height: 50)
                .padding()
                .foregroundColor(.black)
                .background(backgroundColor)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(backgroundColor, lineWidth: 2)
                )
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(text: "Photocard", backgroundColor: .blue)
    }
}
