//
//  UrReciptsApp.swift
//  UrRecipts
//
//  Created by Carlos Tipán on 25/5/24.
//

import SwiftUI
import SwiftData

@main
@MainActor
struct UrReciptsApp: App {
    @Environment(\.colorScheme) var colorScheme
    
    let modelContainer: ModelContainer = {
        do {
          let container = try ModelContainer(for: Receipt.self, ReceiptType.self)
            
          var itemFetchDescriptor = FetchDescriptor<ReceiptType>()
          itemFetchDescriptor.fetchLimit = 1
          
            // Verificar si hay elementos en la tienda persistente
            let items = try container.mainContext.fetch(itemFetchDescriptor)
            if items.isEmpty {
                // Si la tienda está vacía, insertar elementos por defecto
                let types = [
                    ReceiptType(name: "Salud", icon: "pills"),
                    ReceiptType(name: "Gastos", icon: "creditcard"),
                    ReceiptType(name: "Otros", icon: "list.bullet.rectangle.portrait")
                ]
                
                for item in types {
                    container.mainContext.insert(item)
                }
                
                // Guardar el contexto para persistir los cambios
                try container.mainContext.save()
            }
            
            return container
      } catch {
        fatalError("Could not initialize ModelContainer")
      }
    }()
    
    var body: some Scene {
        WindowGroup {
//            ThemedBackground {
//                ContentView()
//            }
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
