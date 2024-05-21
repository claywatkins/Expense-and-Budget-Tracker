//
//  CalendarView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/21/24.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var settingsService: SettingsService
    let date: Date
    @State private var days: [Date] = []
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let coloums = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        VStack {
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { idx in
                        Text(daysOfWeek[idx])
                        .fontWeight(.black)
                        .foregroundStyle(settingsService.calendarColor)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: coloums, content: {
                ForEach(days, id: \.self) { day in
                    if day.monthInt != date.monthInt {
                        Text("")
                    } else {
                        Text(day.formatted(.dateTime.day()))
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                Circle()
                                    .foregroundStyle(
                                        Date.now.startOfDay == day.startOfDay
                                        ? settingsService.currendDayColor.opacity(0.3)
                                        : settingsService.calendarColor.opacity(0.3)
                                    )
                            )
                    }
                }
            })
        }
        .padding()
        .onAppear {
            days = date.calendarDisplayDays
        }
        .onChange(of: date) {
            days = date.calendarDisplayDays
        }
    }
}

#Preview {
    @StateObject var settingsService = SettingsService()
    
    return CalendarView(date: Date.now)
            .environmentObject(settingsService)
}
