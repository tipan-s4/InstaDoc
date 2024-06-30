//
//  OptionalSearchableViewModifier.swift
//  InstaDoc
//
//  Created by Carlos Tipán on 27/6/24.
//

import SwiftUI

struct OptionalSearchableViewModifier: ViewModifier{
    let isSearchable: Bool
    @Binding var searchString: String
    
    func body(content: Content) -> some View {
        switch isSearchable{
        case true:
            content
                .searchable(text: $searchString, prompt: "Buscar")
        case false:
            content
        }
    }
}
