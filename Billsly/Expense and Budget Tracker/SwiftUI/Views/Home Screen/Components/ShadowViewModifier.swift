//
//  ShadowViewModifier.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/7/24.
//

import SwiftUI

struct ShadowViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .black.opacity(0.7), radius: 5, x: 2, y: 2)
    }
}
