//
//  RowView.swift
//  UrRecipts
//
//  Created by Carlos Tipán on 25/5/24.
//

import Foundation
import SwiftUI

struct RowView: View {
    
    var body: some View {
        
        HStack() {
            
            Image(systemName: "plus.circle")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            VStack(alignment: .leading) {
                Text("Titulo")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("Titulo del la receta...")
            }
            
            Spacer()
            
        }
        .padding()
        
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView()
    }
}
