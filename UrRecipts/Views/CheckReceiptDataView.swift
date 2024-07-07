//
//  CheckReceiptDataView.swift
//  UrRecipts
//
//  Created by Carlos Tipán on 26/5/24.
//

import Foundation
import SwiftUI
import EventKit
import EventKitUI
import SwiftData

struct CheckReceiptDataView: View {
    var selectedImage: UIImage?
    @Binding var navigateToCheckReceiptDataView: Bool
    @ObservedObject var viewModel: ReceiptViewModel
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @Environment(\.modelContext) var context
    @State private var showingSheet: Bool = false
    @State private var showEventEditView: Bool = false
    @State private var navigateToHome: Bool = false
    @State private var eventStore = EKEventStore()
    @State private var event: EKEvent?
    
    @State var groups: [ReceiptType]
    
    var body: some View {
            VStack (alignment: .leading) {
                if selectedImage != nil {
                    List {
                        ReceiptGeneralDataView(title: "", receipt: viewModel.receipt, groups: groups)
                        
                        Section(header:
                            HStack {
                                Text("Descripcion")
                                Spacer()
                                Button(action: {
                                    showingSheet = true
                                }) {
                                    Image(systemName: "doc.text.magnifyingglass")
                                }
                                .padding(.trailing, 10)
                            }
                        ) {
                            ForEach(0..<viewModel.receipt.fullInfo.count, id: \.self) { index in
                                TextField("Editar", text: $viewModel.receipt.fullInfo[index])
                            }
                            .onDelete(perform: { indexSet in
                                viewModel.receipt.fullInfo.remove(atOffsets: indexSet)
                            })
                            .onMove(perform: { indices, newOffset in
                                viewModel.receipt.fullInfo.move(fromOffsets: indices, toOffset: newOffset)
                            })
                            Button(action: {
                                viewModel.receipt.fullInfo.append("")
                                viewModel.objectWillChange.send() 
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Agregar nuevo")
                                }
                            }
                        }
                        .listRowBackground(Color("CardColor"))
                    }
                                            
                    
                } else {
                    Text("No image selected")
                        .font(.largeTitle)
                        .padding()
                }

            }
            .padding(.top, 10.0)
            .navigationTitle("Resumen")
            .onAppear {
                if let image = selectedImage {
                    viewModel.recognizeText(image: image)
                }
        }
        .scrollContentBackground(.hidden)
        .background(Color("CustomBackgroundColor"))
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: addEvent) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(Color("IconColor"))
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: saveEvent) {
                    Text("Guardar")
                        .foregroundColor(Color("IconColor"))
                }
            }
        }
        .background(.clear)
        .sheet(isPresented: $showEventEditView) {
            if let event = createEvent() {
                EventEditView(event: event, eventStore: eventStore) { success in
                    if success {
                        print("Event was added to the calendar.")
                        
                        DispatchQueue.main.async {
                            if let url = URL(string: "calshow:\(event.startDate.timeIntervalSinceReferenceDate)") {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    } else {
                        print("Event addition was canceled or failed.")
                    }
                }
            }
        }
        .sheet(isPresented: $showingSheet) {
            FullDescriptionView(isPresented: $showingSheet, viewModel: viewModel)
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled)
                .presentationBackground(.background)
        }
        .navigationDestination(isPresented: $navigateToHome) {
            ContentView()
        }
    }
    
    private func addEvent() {
        eventStore.requestFullAccessToEvents { granted, error in
             if granted && error == nil {
                 print("Access granted to the calendar.")
                 DispatchQueue.main.async {
                     showEventEditView = true
                 }
             } else {
                 print("Access denied to the calendar or error: \(String(describing: error))")
             }
         }
     }
     
     private func createEvent() -> EKEvent? {
         guard !viewModel.receipt.title.isEmpty,
               let date = viewModel.receipt.date else {
             return nil
         }
         
         let event = EKEvent(eventStore: eventStore)
         event.title = viewModel.receipt.title
         event.startDate = date
         event.endDate = date.addingTimeInterval(3600)
         event.location = viewModel.receipt.address
         event.notes = viewModel.receipt.info ?? viewModel.receipt.fullInfo.joined(separator: "\n")
         event.calendar = eventStore.defaultCalendarForNewEvents
         event.addAlarm(EKAlarm(relativeOffset: -3600))
         
         return event
     }
    
    private func saveEvent() {
        let receipt = viewModel.receipt
        
        if (receipt.title.isEmpty || receipt.date == nil || receipt.type == nil) {
            return
        }
        
        receipt.info = viewModel.receipt.info ?? viewModel.receipt.fullInfo.joined(separator: "\n")

        context.insert(receipt)
        self.navigateToCheckReceiptDataView = false
    }
}

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}

//struct CheckReceiptDataView_Previews: PreviewProvider {
//    @State static private var navigateToCheckReceiptDataView = true
//    
//    static var previews: some View {
//        let sampleImage = UIImage(named: "example1")
//        let viewModel = ReceiptViewModel()
//        viewModel.receipt = Receipt(title: "Sample Title", info: "Sample Description", address: "Sample Address", phone: "1234567890", email: "sample@example.com", date: Date())
//        
//        return NavigationView {
//            CheckReceiptDataView(selectedImage: sampleImage, navigateToCheckReceiptDataView: $navigateToCheckReceiptDataView, viewModel: viewModel, groups: [
//                ReceiptType(name: "Salud", icon: "pills"),
//                ReceiptType(name: "Gastos", icon: "creditcard"),
//                ReceiptType(name: "Otros", icon: "list.bullet.rectangle.portrait")
//            ])
//        }
//    }
//}
