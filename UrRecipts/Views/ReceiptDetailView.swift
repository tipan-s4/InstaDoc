//
//  EditReceiptView.swift
//  InstaDoc
//
//  Created by Carlos Tipán on 29/6/24.
//

import SwiftUI

struct ReceiptDetailView: View {
    @State var receipt: Receipt
    @Environment(\.modelContext) var context
    
    @State var groups: [ReceiptType]
    
    var body: some View {
        NavigationView {
            VStack{
                List{
                    ReceiptGeneralDataView(title: "Resumen", receipt: receipt, groups: groups)
                    
                    Section(header: Text("Descripción")) {
                        TextField("", text: Binding<String>(
                            get: { receipt.info ?? "" },
                            set: { newValue in receipt.info = newValue }
                        ), axis: .vertical)
                    }
                    .listRowBackground(Color("CardColor"))
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                }
                
            }
            .scrollContentBackground(.hidden)
            .background(Color("CustomBackgroundColor"))
        }
    }
}

#Preview {
    ReceiptDetailView(receipt:
        Receipt(title: "Sample Title", info: "Sample Description", address: "Sample Address", phone: "1234567890", email: "sample@example.com", date: Date())
    , groups: [])
}
