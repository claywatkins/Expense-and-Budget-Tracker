//
//  CalendarView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/21/24.
//

import SwiftUI

struct CalendarView: View {
    @State private var color: Color = .blue
    @State private var date = Date.now
    let daysOfWeek = []
    var body: some View {
        VStack {
            LabeledContent("Calendar Color") {
                ColorPicker("", selection: $color, supportsOpacity: false)
            }
        }
    }
}

#Preview {
    CalendarView()
}
