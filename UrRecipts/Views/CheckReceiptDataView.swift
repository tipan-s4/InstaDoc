//
//  CheckReceiptDataView.swift
//  UrRecipts
//
//  Created by Carlos Tipán on 26/5/24.
//

import Foundation
import SwiftUI
import EventKit

struct CheckReceiptDataView: View {
    var selectedImage: UIImage?
    @ObservedObject var viewModel: ReceiptViewModel
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @State private var showingSheet: Bool = false
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                
                if selectedImage != nil {
                    
                    GroupBox {
                        VStack(alignment: .leading) {
                            
                            createGroup(label: "Titulo", text: Binding<String>(
                                get: { viewModel.receipt.title ?? "" },
                                set: { newValue in viewModel.receipt.title = newValue }
                            ))
                            
                            createGroup(label: "Teléfono", text: Binding<String>(
                                get: { viewModel.receipt.phone ?? "" },
                                set: { newValue in viewModel.receipt.phone = newValue }
                            ))
                            
                            createGroup(label: "Email", text: Binding<String>(
                                get: { viewModel.receipt.email ?? "" },
                                set: { newValue in viewModel.receipt.email = newValue }
                            ))
                            
                            createGroup(label: "Dirección", text: Binding<String>(
                                get: { viewModel.receipt.address ?? "" },
                                set: { newValue in viewModel.receipt.address = newValue }
                            ))
                            
                            DatePicker(selection: Binding<Date>(
                                get: { viewModel.receipt.date ?? Date() },
                                set: { newValue in viewModel.receipt.date = newValue }
                            ),
                               displayedComponents: [.hourAndMinute, .date],
                                label: {
                                    Text("Fecha")
                                }
                            )
                        }
                    }
                    .padding()
                    
                    List {
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
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Agregar nuevo")
                                }
                            }
                        }
                    }
                    .frame(minHeight: minRowHeight * CGFloat(viewModel.receipt.fullInfo.count))
                    .listStyle(.automatic)
                                            
                    
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
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    let eventStore : EKEventStore = EKEventStore()
                    
                    eventStore.requestAccess(to: .event) { (granted, error) in
                      
                      if (granted) && (error == nil) {
                          print("granted \(granted)")
                          print("error \(String(describing: error))")
                          
                          let event:EKEvent = EKEvent(eventStore: eventStore)
                          
                          event.title = viewModel.receipt.title
                          event.startDate = viewModel.receipt.date
                          event.endDate = viewModel.receipt.date
                          event.location = viewModel.receipt.address
                          event.notes = viewModel.receipt.description ?? viewModel.receipt.fullInfo.joined(separator: "\n")
                          event.calendar = eventStore.defaultCalendarForNewEvents
                          event.addAlarm(EKAlarm(relativeOffset: -3600))
                          
                          do {
                              try eventStore.save(event, span: .thisEvent)
                                                            
                              DispatchQueue.main.async {
                                  if let url = URL(string: "calshow:\(event.startDate.timeIntervalSinceReferenceDate)") {
                                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                  }
                              }
                              
                          } catch let error as NSError {
                              print("failed to save event with error : \(error)")
                          }
                          print("Saved Event")
                      }
                      else{
                      
                          print("failed to save event with error : \(String(describing: error)) or access not granted")
                      }
                    }   
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showingSheet) {
            FullDescriptionView(isPresented: $showingSheet, viewModel: viewModel)
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled)
                .presentationBackground(.background)
        }
    }
    
    @ViewBuilder
    func createGroup(label: String, text: Binding<String>, drawSeparator: Bool = true) -> some View {
        Group{
            Text(label)
                .font(.footnote)
                .fontWeight(.light)
                .foregroundColor(Color.gray)
                .padding(.bottom, -2.0)
            
            TextField(label, text: text)
                .accessibilityLabel(label)
            
            if drawSeparator {
                Divider()
                    .padding(.vertical, 4)
            }
        }
    }
}

struct CheckReceiptDataView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleImage = UIImage(named: "example1")
        let viewModel = ReceiptViewModel()
        viewModel.receipt = Receipt(id: 1, title: "Sample Title", description: "Sample Description", address: "Sample Address", phone: "1234567890", email: "sample@example.com", date: Date())
        
        return NavigationView {
            CheckReceiptDataView(selectedImage: sampleImage, viewModel: viewModel)
        }
    }
}
