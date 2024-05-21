//
//  BillsView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/8/24.
//

import SwiftUI

struct BillsView: View {
    @EnvironmentObject var userService: UserController
    @EnvironmentObject var settingsService: SettingsService
    @State private var date = Date()
    @State private var expandListView = false
    
    var body: some View {
        VStack {
            CalendarHeaderView()
                .environmentObject(userService)
                .environmentObject(settingsService)
            BillListSection(billList: userService.unpaidBills,
                            expandListView: $expandListView,
                            date: $date,
                            sectionTitle: "Unpaid Bills")
                .environmentObject(userService)
        }
        .background(.quaternary)
        .sheet(isPresented: $expandListView, content: {
            ManageBillsView(billList: $userService.currentList)
                .environmentObject(userService)
        })
    }
}

#Preview {
    @StateObject var userService = UserController()
    @StateObject var settingsService = SettingsService()
    
    return BillsView()
        .environmentObject(userService)
        .environmentObject(settingsService)
}


