//
//  Receipt.swift
//  UrRecipts
//
//  Created by Carlos Tipán on 25/5/24.
//

import Foundation
import SwiftUI

struct Receipt {
    
    var id: Int?
    var title: String?
    var description: String?
    var address: String?
    var phone: String?
    var email: String?
    var fullInfo = [String]()
    var date: Date?
    var important: Bool?
    var grupo: Int?
}
