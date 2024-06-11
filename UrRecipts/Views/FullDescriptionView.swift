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
            .navigationBarTitle("Editar descripción", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancelar") {
                isPresented = false
            }, trailing: Button("Guardar") {
                viewModel.receipt.description = text
                viewModel.receipt.fullInfo = text.components(separatedBy: "\n")
                isPresented = false
            })
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
