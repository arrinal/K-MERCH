//
//  ImageCardView.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 20/10/21.
//

import SwiftUI
import SwURL

struct ImageCardView: View {
    var img: String
    var title: String
    
    var body: some View {
        VStack {
            RemoteImageView(url: URL(string: img)!).imageProcessing({ image in
                return image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            })
                .frame(width: 200, height: 200)
                .cornerRadius(10)
            Text(title)
                .frame(width: 200)
                .frame(minHeight: 0, maxHeight: 100)
            
            Spacer()
        }
        
    }
}

struct ImageCardView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCardView(img: "1", title: "Albumfjiefjeriijgirejgirgjiefefhuiefheuifhreuirfejieiughiergerghreuighrgiurhgeuhguirehgherivervhfjshejksfhjesfhsejffhsjkefhejskfheskjfheskjfhejkhfeughriughreiughreuighreihfghfnfgnfgngfnffesifhiufhseurfihsiughrisuhgruisdghriughrugngfnfnughksieivirgjierjesijdfiufjiufjsiujspokopow")
    }
}
