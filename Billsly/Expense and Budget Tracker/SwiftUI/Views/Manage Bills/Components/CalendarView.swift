//
//  CalendarView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/21/24.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @EnvironmentObject var settingsService: SettingsService
    @EnvironmentObject var billService: BillService
    @State private var days: [Date] = []
    @State private var counts: [Int: Int] = [:]
    @State private var tappedOnDay = false
    @State private var tappedDayInt = 0
    let date: Date
    @Binding var billType: BillSelection
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let coloums = Array(repeating: GridItem(.flexible()), count: 7)
    
    @Query(sort: \NewBill.dueByDate, order: .forward) var allBills: [NewBill]
    
    @Query(filter: #Predicate<NewBill> { bill in
        bill.hasBeenPaid == false
    }, sort: \NewBill.dueByDate, order: .forward) var unpaidBills: [NewBill]
    
    @Query(filter: #Predicate<NewBill> { bill in
        bill.hasBeenPaid == true
    }, sort: \NewBill.dueByDate, order: .forward) var paidBills: [NewBill]

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
            counts = setupCounts(selection: billType)
        }
        .onChange(of: date) {
            days = date.calendarDisplayDays
            counts = setupCounts(selection: billType)
        }
        .onChange(of: billType) {
            counts = setupCounts(selection: billType)
        }
        .onChange(of: unpaidBills.count) {
            counts = setupCounts(selection: billType)
        }
        .onChange(of: paidBills.count) {
            counts = setupCounts(selection: billType)
        }
        .sheet(isPresented: $tappedOnDay, content: {
            BillsForDayView(bills: billService.getBillsForDay(allBills: allBills, dayInt: tappedDayInt))
                .presentationDetents([.fraction(0.3)])
        })
    }
    
    private func setupCounts(selection: BillSelection) -> [Int: Int] {
        switch selection {
        case .all:
            let mappedItems = allBills.map{($0.dueByDate.dayInt, 1)}
            return Dictionary(mappedItems, uniquingKeysWith: +)
        case .paid:
            let mappedItems = paidBills.map{($0.dueByDate.dayInt, 1)}
            return Dictionary(mappedItems, uniquingKeysWith: +)
        case .unpaid:
            let mappedItems = unpaidBills.map{($0.dueByDate.dayInt, 1)}
            return Dictionary(mappedItems, uniquingKeysWith: +)
        }
    }
}

#Preview {
    @StateObject var settingsService = SettingsService()
    @StateObject var billService = BillService()
    
    return CalendarView(date: Date.now, billType: .constant(.all))
            .environmentObject(settingsService)
            .environmentObject(billService)
}
