//
//  RowView.swift
//  UrRecipts
//
//  Created by Carlos Tipán on 25/5/24.
//

import Foundation
import SwiftUI

struct RowView: View {
    
    let receipt: Receipt
    
    var body: some View {
        
        HStack() {
            
            Image(systemName: receipt.type?.icon ?? "list.bullet.rectangle.portrait")
                .padding(.trailing, 10)
                .imageScale(.large)
                .foregroundColor(Color("IconColor"))
            
            VStack(alignment: .leading) {
                Text(receipt.title.capitalized)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("TextColor"))
                Text(receipt.date ?? Date(), format: Date.FormatStyle().year().month().day())
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
            }
            
            Spacer()
            
        }
        .background(Color("CardColor"))
        
    }
}

struct RowView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let receipt = Receipt(title: "Sample Title", info: "Sample Description", address: "Sample Address", phone: "1234567890", email: "sample@example.com", date: Date())

        RowView(receipt: receipt)
    }
}
