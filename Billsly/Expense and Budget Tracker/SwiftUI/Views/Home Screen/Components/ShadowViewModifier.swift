//
//  ShadowViewModifier.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/7/24.
//

import SwiftUI

struct ShadowViewModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .shadow(color: (colorScheme == .light ? .black.opacity(0.5) : .secondary.opacity(0.5)), radius: 3, x: 2, y: 2)
    }
}
