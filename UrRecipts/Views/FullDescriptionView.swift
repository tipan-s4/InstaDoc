//
//  FullDescriptionView.swift
//  UrRecipts
//
//  Created by Carlos Tipán on 8/6/24.
//

import Foundation
import SwiftUI

struct FullDescriptionView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: ReceiptViewModel
    @State private var text: String = ""
    @State private var isTextInitialized: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                TextEditor(text: $text)
                    .onAppear {
                        if !isTextInitialized {
                            text = viewModel.receipt.fullInfo.joined(separator: "\n")
                            isTextInitialized = true
                        }
                    }
            }
            .scrollContentBackground(.hidden)
            .background(Color("CustomBackgroundColor"))
            .navigationBarTitle("Editar descripción", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    isPresented = false
                }) {
                    Text("Cancelar")
                        .foregroundColor(Color("IconColor"))
                },
                trailing: Button(action: {
                    viewModel.receipt.info = text
                    viewModel.receipt.fullInfo = text.components(separatedBy: "\n")
                    isPresented = false
                }) {
                    Text("Guardar")
                        .foregroundColor(Color("IconColor"))
                }
            )

        }
    }
}

struct FullDescriptionView_Previews: PreviewProvider {
    @State static var isPresented = true
    
    static var previews: some View {
        // Proporcionar un ejemplo de ReceiptViewModel con algunos datos
        let viewModel = ReceiptViewModel()
        viewModel.receipt.fullInfo = ["Ejemplo de texto 1", "Ejemplo de texto 2"]
        
        return FullDescriptionView(isPresented: $isPresented, viewModel: viewModel)
    }
}
