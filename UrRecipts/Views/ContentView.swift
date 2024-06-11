//
//  ContentView.swift
//  UrRecipts
//
//  Created by Carlos Tipán on 25/5/24.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 5) {
            
            HStack {
                
                NavigationStack {
                    Text("Searching for \(searchText)")
                        .navigationTitle("Receipts")
                }
                .searchable(text: $searchText)
            }
            
            Spacer()
            
            VStack {
                
                Button(action: {}) {
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
