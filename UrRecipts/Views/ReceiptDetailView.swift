//
//  EditReceiptView.swift
//  InstaDoc
//
//  Created by Carlos Tipán on 29/6/24.
//

import SwiftUI

struct EditReceiptView: View {
    @State var receipt: Receipt
    @Environment(\.modelContext) var context
    
    var body: some View {
        NavigationView {
            VStack{
                List{
                    Section(header: Text("Resumen")) {
                        createGroup(label: "Titulo", text: Binding<String>(
                            get: { receipt.title ?? "" },
                            set: { newValue in receipt.title = newValue }
                        ))
                        
                        createGroup(label: "Teléfono", text: Binding<String>(
                            get: { receipt.phone ?? "" },
                            set: { newValue in receipt.phone = newValue }
                        ))
                        
                        createGroup(label: "Email", text: Binding<String>(
                            get: { receipt.email ?? "" },
                            set: { newValue in receipt.email = newValue }
                        ))
                        
                        createGroup(label: "Dirección", text: Binding<String>(
                            get: { receipt.address ?? "" },
                            set: { newValue in receipt.address = newValue }
                        ))
                        
                        DatePicker(selection: Binding<Date>(
                            get: { receipt.date ?? Date() },
                            set: { newValue in receipt.date = newValue }
                        ),
                        displayedComponents: [.hourAndMinute, .date],
                        label: {
                            Text("Fecha")
                        })
                        .padding(.top, 0.5)
                    }
                    
                    Section(header: Text("Descripción")) {
                        TextEditor(text:  Binding<String>(
                            get: { receipt.info ?? "" },
                            set: { newValue in receipt.info = newValue }
                        ))
                        .frame(minHeight: 160)
                    }
                }
                .scrollDisabled(false)
            }
            .navigationTitle("Editar Ticket")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: saveEvent) {
                        Text("Guardar")
                    }
                }
            }
        }
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
    }
    
    private func saveEvent() {
        if (receipt.title == nil || receipt.date == nil) {
            return
        }

        context.insert(receipt)
    }

}

#Preview {
    EditReceiptView(receipt:
        Receipt(title: "Sample Title", info: "Sample Description", address: "Sample Address", phone: "1234567890", email: "sample@example.com", date: Date())
    )
}
