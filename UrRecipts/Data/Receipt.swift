//
//  Receipt.swift
//  UrRecipts
//
//  Created by Carlos Tipán on 25/5/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Receipt {
    var title: String
    var info: String?
    var address: String?
    var phone: String?
    var email: String?
    var date: Date?
    
    @Relationship var type: ReceiptType?
//    var important: Bool?
    
    @Transient
    var fullInfo = [String]()
    
    init(){
        self.title = ""
    }
    
    init(title: String, info: String, address: String, phone: String, email: String, date: Date) {
        self.title = title
        self.info = info
        self.address = address
        self.phone = phone
        self.email = email
        self.date = date
        self.fullInfo = []
    }
}
