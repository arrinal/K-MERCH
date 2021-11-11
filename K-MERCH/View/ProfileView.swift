//
//  ProfileView.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 22/10/21.
//

import SwiftUI

struct ProfileView: View {
    @Binding var isActive: Bool
    let text: String
    
    var body: some View {
        if isActive {
            Text(text)
                .font(.footnote)
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 57/255, green: 60/255, blue: 65/255), lineWidth: 2)
                )
                .background(Color(red: 57/255, green: 60/255, blue: 65/255))
                .cornerRadius(10)
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
