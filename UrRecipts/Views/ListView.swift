//
//  ListView.swift
//  UrRecipts
//
//  Created by Carlos Tipán on 25/5/24.
//

import Foundation
import SwiftUI


private let receipts = [
    Receipt(id: 1, title: "receta", description: "La descripcion de la receta es deede", date: Date(), important: false, grupo: 1)
]

struct ListView: View {
    
    var body: some View {
        List {
//            RowView(receipt: Receipt(id: 1, title: "receta", description: "La descripcion de la receta es deede", date: Date(), important: false, grupo: 1))
        }
        
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
