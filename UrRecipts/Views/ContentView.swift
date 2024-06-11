//
//  ContentView.swift
//  UrRecipts
//
//  Created by Carlos Tipán on 25/5/24.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State private var navigateToCheckReceiptDataView = false
    
    @State private var searchText = ""
    @State private var showSearchBar = false
    @ObservedObject var viewModel = ReceiptViewModel()
    
    func openCamera() {
        self.showCamera.toggle()
    }
    
    var body: some View {
        
        NavigationStack {
            
            VStack(alignment: .center, spacing: 5) {
                
                if showSearchBar {
                    HStack {
                        Text("Searching for \(searchText)")
                    }
                    .searchable(text: $searchText)
                }
                
                Spacer()
                
            }
            .navigationTitle("Receipts")
            .padding()
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    HStack {
                        
                        Menu {
                            Button(action: {
                                // Código para el primer ítem del menú
                            }) {
                                Label("Pin", systemImage: "pin.fill")
                            }
                            
                            Button(action: {
                                // Código para el segundo ítem del menú
                            }) {
                                Label("Lock", systemImage: "lock")
                            }
                            
                            Button(action: {
                                // Código para el tercer ítem del menú
                            }) {
                                Label("Search", systemImage: "magnifyingglass")
                            }
                            
                            Button(action: {
                                // Código para el tercer ítem del menú
                            }) {
                                Label("Nuevo", systemImage: "plus")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                        }

                        Button(action: {
                            showSearchBar.toggle()
                        }) {
                            Image(systemName: "magnifyingglass")
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                        }
                        
                        Button(action: openCamera) {
                            Image(systemName: "plus")
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                        }
                        .fullScreenCover(isPresented: self.$showCamera) {
                            AccessCameraView(selectedImage: self.$selectedImage, navigateToCheckReceiptDataView: self.$navigateToCheckReceiptDataView)
                        }
                    }
                    .navigationDestination(isPresented: self.$navigateToCheckReceiptDataView) {
                        CheckReceiptDataView(selectedImage: self.selectedImage, viewModel: self.viewModel)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
