//
//  CalendarHeaderView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/21/24.
//

import SwiftUI

struct CalendarHeaderView: View {
    @EnvironmentObject var userService: UserController
    @EnvironmentObject var settingsService: SettingsService
    @State private var monthDate = Date.now
    @State private var years: [Int] = []
    @State private var selectedMonth = Date.now.monthInt
    @State private var selectedYear = Date.now.yearInt
    let months = Date.fullMonthNames
    
    var body: some View {
        NavigationStack {
            VStack{
                HStack {
                    Picker("", selection: $selectedMonth) {
                        ForEach(months.indices, id: \.self) { idx in
                            Text(months[idx]).tag(idx + 1)
                        }
                    }
                    
                    Picker("", selection: $selectedYear) {
                        ForEach(years.indices, id:  \.self) { idx in
                            Text(String(years[idx])).tag(idx + 1)
                        }
                    }
                }
                .buttonStyle(.bordered)
                CalendarView(date: monthDate)
                    .environmentObject(settingsService)
                Spacer()
            }
            .onAppear {
                years = userService.billsInYear
            }
            .onChange(of: selectedYear) {
                updateDate()
            }
            .onChange(of: selectedMonth) {
                updateDate()
            }
        }
    }
    
    func updateDate() {
        monthDate = Calendar.current.date(from: DateComponents(year: selectedYear,
                                                               month: selectedMonth,
                                                               day: 1))!
    }
}

#Preview {
    @StateObject var userService = UserController()
    @StateObject var settingsService = SettingsService()
    
    return CalendarHeaderView()
        .environmentObject(userService)
        .environmentObject(settingsService)
}
