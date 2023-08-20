//
//  Nextview.swift
//  LocalNotifications
//
//  Created by Carmen Lucas on 20/8/23.
//

import SwiftUI

enum NextView: String, Identifiable {
    case promo, renew
    var id: String{
        self.rawValue
    }
    
    @ViewBuilder
    func view() -> some View{
        switch self {
         case .promo:
            Text("Promotional Offer")
         case .renew:
           VStack{
               Text("Renew subscription")
                   .font(.largeTitle)
               Image(systemName: "dollarsign.circle.fill")
                   .font(.system(size: 128))
           }
        }
    }
}

