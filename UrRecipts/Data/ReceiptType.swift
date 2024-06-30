//
//  Group.swift
//  InstaDoc
//
//  Created by Carlos Tipán on 29/6/24.
//

import Foundation
import SwiftData

@Model
class ReceiptType {
    var name: String
    var icon: String
    
    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
    }
}
