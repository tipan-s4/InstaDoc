//
//  ReceiptGeneralDataView.swift
//  InstaDoc
//
//  Created by Carlos Tipán on 30/6/24.
//

import SwiftUI

struct ReceiptGeneralDataView: View {
    
    var title: String
    @State var receipt: Receipt
    @State var groups: [ReceiptType]
    
    var body: some View {
        Section(header: Text("")) {
            createGroup(label: "Titulo", text: $receipt.title)

            createGroup(label: "Teléfono", text: $receipt.phone.toUnwrapped(defaultValue: ""))

            createGroup(label: "Email", text: $receipt.email.toUnwrapped(defaultValue: ""))

            createGroup(label: "Dirección", text:$receipt.address.toUnwrapped(defaultValue: ""))
            
            
            Picker("Tipo", selection: $receipt.type) {
                Text("Seleccione un tipo").tag(nil as ReceiptType?)
                ForEach(groups, id: \.self) { group in
                    Text(group.name).tag(group as ReceiptType?)
                }
            }
            .accentColor(Color("IconColor"))
            .padding(.vertical, 1.0)
            .pickerStyle(.menu)
            
            DatePicker(selection: $receipt.date.toUnwrapped(defaultValue: Date()),
                       displayedComponents: [.hourAndMinute, .date],
                       label: {
                Text("Fecha")
            })
            .padding(.top, 0.5)
        }
        .listRowBackground(Color("CardColor"))
    }
    
    func createGroup(label: String, text: Binding<String>, drawSeparator: Bool = true) -> some View {
        VStack(alignment: .leading){
            Text(label)
                .font(.footnote)
                .fontWeight(.light)
                .foregroundColor(Color.gray)
                .padding(.bottom, -2.0)
            
            TextField(label, text: text)
                .accessibilityLabel(label)
        }
        .background(Color("CardColor"))
    }
}

//#Preview {
//    ReceiptGeneralDataView()
//}
