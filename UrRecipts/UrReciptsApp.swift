//
//  UrReciptsApp.swift
//  UrRecipts
//
//  Created by Carlos Tipán on 25/5/24.
//

import SwiftUI

@main
struct UrReciptsApp: App {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(colorScheme == .dark ? Color("CustomBackgroundColorDark"): Color("CustomBackgroundColor"))
        }
    }
}
