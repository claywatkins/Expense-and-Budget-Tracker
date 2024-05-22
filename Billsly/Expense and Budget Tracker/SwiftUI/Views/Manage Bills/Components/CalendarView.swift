//
//  CalendarView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/21/24.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var settingsService: SettingsService
    @EnvironmentObject var userService: UserController
    @State private var days: [Date] = []
    @State private var counts: [Int: Int] = [:]
    @State private var tappedOnDay = false
    @State private var tappedDayInt = 0
    let date: Date
    @Binding var billType: BillSelection
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
                                        ? settingsService.currendDayColor.opacity(counts[day.dayInt] != nil ? 0.8 : 0.3)
                                        : settingsService.calendarColor.opacity(counts[day.dayInt] != nil ? 0.8 : 0.3)
                                    )
                            )
                            .overlay(alignment: .bottomTrailing) {
                                if let count = counts[day.dayInt] {
                                    Image(systemName: count <= 50 ? "\(count).circle.fill" : "plus.circle.fill")
                                        .foregroundColor(.secondary)
                                        .imageScale(.medium)
                                        .background(
                                            Color(.systemBackground)
                                                .clipShape(.circle)
                                        )
                                        .offset(x: 5, y: 5)
                                }
                            }
                            .onTapGesture {
                                if let _ = counts[day.dayInt] {
                                    tappedOnDay.toggle()
                                    tappedDayInt = day.dayInt
                                }
                            }
                    }
                }
            })
        }
        .padding()
        .onAppear {
            days = date.calendarDisplayDays
            counts = userService.setupCounts(selection: billType)
        }
        .onChange(of: date) {
            days = date.calendarDisplayDays
            counts = userService.setupCounts(selection: billType)
        }
        .onChange(of: billType) {
            counts = userService.setupCounts(selection: billType)
        }
        .sheet(isPresented: $tappedOnDay, content: {
            BillsForDayView(bills: userService.getBillsForDay(dayInt: tappedDayInt))
                .presentationDetents([.fraction(0.3)])
        })
    }
}

#Preview {
    @StateObject var settingsService = SettingsService()
    @StateObject var userService = UserController()
    
    return CalendarView(date: Date.now, billType: .constant(.all))
            .environmentObject(settingsService)
            .environmentObject(userService)
}
