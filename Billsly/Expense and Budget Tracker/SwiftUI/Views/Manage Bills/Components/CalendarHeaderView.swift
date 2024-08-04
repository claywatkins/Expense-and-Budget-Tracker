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
    @EnvironmentObject var billService: BillService
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
                    
                    Picker("", selection: $billService.billListType) {
                        ForEach(BillSelection.allCases, id: \.self) { billType in
                            Text(billType.rawValue).tag(billType)
                        }
                    }
                }
                .buttonStyle(.bordered)
                CalendarView(date: monthDate, billType: $billService.billListType)
                    .environmentObject(settingsService)
                    .environmentObject(userService)
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
