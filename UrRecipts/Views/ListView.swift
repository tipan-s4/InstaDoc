//
//  ListView.swift
//  UrRecipts
//
//  Created by Carlos Tipán on 25/5/24.
//

import Foundation
import SwiftUI
import SwiftData

struct ListView: View {
    @Environment(\.modelContext) var context
    
    @Query var receipts: [Receipt]
    @State var groups: [ReceiptType]
    
    @Binding var emptySearch: Bool
    
    var searchText: String
    var groupSelected: ReceiptType?
    
    init(emptySearch: Binding<Bool>, searchText: String, groups: [ReceiptType], groupSelected: ReceiptType?) {
        _emptySearch = emptySearch
        self.searchText = searchText
        self.groups = groups
        self.groupSelected = groupSelected
        
        let groupId = groupSelected?.persistentModelID
        
        _receipts = Query(
                filter: #Predicate {
                    (searchText.isEmpty || $0.title.localizedStandardContains(searchText)) &&
                    (groupId == nil || $0.type?.persistentModelID == groupId)
                },
                sort: \.date
        )
        
        UITableView.appearance().backgroundColor = UIColor(named: "CustomBackgroundColor")
    }
    
    var body: some View {
        List {
            ForEach(receipts) { receipt in
                NavigationLink(destination: ReceiptDetailView(receipt: receipt, groups: groups).navigationBarTitle("Editar")) {
                    RowView(receipt: receipt)
                        .listRowInsets(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                }
            }
            .onDelete(perform: { indexSet in
                for index in indexSet {
                    context.delete(receipts[index])
                }
            })
            .listRowBackground(Color("CardColor"))
        }
        .listStyle(.automatic)
        .onChange(of: receipts) {
            emptySearch = receipts.isEmpty
        }
    }
}

//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListView(receipts: .constant([
//            Receipt(id: 1, title: "Sample Title", info: "Sample Description", address: "Sample Address", phone: "1234567890", email: "sample@example.com", date: Date()),
//            Receipt(id: 2, title: "Sample Title", info: "Sample Description", address: "Sample Address", phone: "1234567890", email: "sample@example.com", date: Date())
//        ]))
//    }
//}
