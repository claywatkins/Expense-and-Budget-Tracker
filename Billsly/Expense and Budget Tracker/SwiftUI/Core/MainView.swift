//
//  MainView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/6/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @EnvironmentObject var userService: UserController
    @EnvironmentObject var settingsService: SettingsService
    @EnvironmentObject var billService: BillService
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) var context
    @State private var selectedIndex = 0
    
    @Query(filter: #Predicate<NewBill> { bill in
        bill.hasBeenPaid == false
    }, sort: \NewBill.dueByDate, order: .forward) var unpaidBills: [NewBill]
    
    @Query(filter: #Predicate<NewBill> { bill in
        bill.hasBeenPaid == true
    }, sort: \NewBill.dueByDate, order: .forward) var paidBills: [NewBill]
    
    @Query(sort: \NewBill.dueByDate, order: .forward) var allBills: [NewBill]
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            HomeScreenView()
                .environmentObject(userService)
                .environmentObject(billService)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            NavigationStack() {
                BillsView()
                    .environmentObject(userService)
                    .environmentObject(settingsService)
                    .environmentObject(billService)
            }
            .tabItem {
                Label("Bills", systemImage: "doc.text")
            }
            .tag(1)
            
            NavigationStack() {
                SettingsView()
                    .navigationTitle("Settings")
                    .environmentObject(userService)
                    .environmentObject(settingsService)
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
            .tag(3)
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                billService.checkForAutoPay(unpaidBills: unpaidBills, context: context)
            } else if newPhase == .background {
                billService.scheduleNotifications(with: unpaidBills)
            }
        }
    }
}
