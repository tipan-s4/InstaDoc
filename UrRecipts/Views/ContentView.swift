//
//  ContentView.swift
//  UrRecipts
//
//  Created by Carlos Tipán on 25/5/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State private var navigateToCheckReceiptDataView = false
    
    @State private var searchText = ""
    @State private var showSearchBar = false
    @State private var emptySearch = false
    @State private var groupSelected: ReceiptType?
    
    @Query var groups: [ReceiptType]
    
    @Environment(\.modelContext) var context
    @ObservedObject var viewModel = ReceiptViewModel()
    
    func openCamera() {
        self.showCamera.toggle()
    }
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(named: "TextColor") ?? UIColor.black]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(named: "TextColor") ?? UIColor.black]
    }
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .center, spacing: 5) {
                ListView(emptySearch: $emptySearch, searchText: searchText, groups: groups, groupSelected: groupSelected)
            }
            .scrollContentBackground(.hidden)
            .background(Color("CustomBackgroundColor"))
            .navigationTitle("Tickets")
            .modifier(OptionalSearchableViewModifier(isSearchable: showSearchBar, searchString: $searchText))
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    HStack {
                        Menu {
                            
                            Button(action: {
                                groupSelected = nil
                            }) {
                                Label("Todos", systemImage: "checklist.checked")
                            }
                            
                            ForEach(groups, id: \.self) { group in
                                Button(action: {
                                    groupSelected = group
                                }) {
                                    Label(group.name, systemImage: group.icon)
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .imageScale(.large)
                                .foregroundColor(Color("IconColor"))
                        }
                        
                        Button(action: {
                            showSearchBar.toggle()
                        }) {
                            Image(systemName: "magnifyingglass")
                                .imageScale(.large)
                                .foregroundColor(Color("IconColor"))
                        }
                        
                        Button(action: openCamera) {
                            Image(systemName: "plus")
                                .imageScale(.large)
                                .foregroundColor(Color("IconColor"))
                        }
                        .fullScreenCover(isPresented: self.$showCamera) {
                            AccessCameraView(selectedImage: self.$selectedImage, navigateToCheckReceiptDataView: self.$navigateToCheckReceiptDataView)
                        }
                    }
                    .navigationDestination(isPresented: self.$navigateToCheckReceiptDataView) {
                        CheckReceiptDataView(selectedImage: self.selectedImage, navigateToCheckReceiptDataView: self.$navigateToCheckReceiptDataView, viewModel: self.viewModel, groups: groups)
                    }
                }
            }
            .overlay {
                if emptySearch {
                    ContentUnavailableView {
                        Label("Ningún Ticket", systemImage: "list.bullet.rectangle.portrait")
                    } description: {
                        Text("Empieza a añadir tickets para verlos en pantalla")
                    } actions: {
                        Button("Añadir Ticket") { openCamera() }
                    }
                    .offset(y: -30)
                }
            }
        }
        .tint(Color("IconColor"))
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
