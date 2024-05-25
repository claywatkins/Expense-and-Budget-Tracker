//
//  BillsView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/8/24.
//

import SwiftUI
import ConfettiSwiftUI

struct BillsView: View {
    @EnvironmentObject var userService: UserController
    @EnvironmentObject var settingsService: SettingsService
    @State private var date = Date()
    @State private var expandListView = false
    @State private var showingPaidBills = false
    @State private var showingAddBill = false
    @State private var counter: Int = 0
    @State private var presentationDetent = PresentationDetent.fraction(0.3)
    
    var body: some View {
        VStack {
            CalendarHeaderView()
                .environmentObject(userService)
                .environmentObject(settingsService)
            
            MiddleButtonsView(showingAddBill: $showingAddBill,
                              showingPaidBills: $showingPaidBills)
                .background(.clear)
                .padding(8)
            
            BillListSection(billType: $userService.billType,
                            expandListView: $expandListView)
                .environmentObject(userService)
        }
        .background(.quaternary)
        .sheet(isPresented: $expandListView, content: {
            ManageBillsView(billList: $userService.currentList)
                .environmentObject(userService)
        })
        .sheet(isPresented: $showingPaidBills) {
            QuickPaidBillView(counter: $counter)
                .environmentObject(userService)
                .presentationDetents(
                    [.fraction(0.3)],
                    selection: $presentationDetent)
        }
        .fullScreenCover(isPresented: $showingAddBill) {
            EditAddBillView(isEdit: false)
                .environmentObject(userService)
        }
        .confettiCannon(counter: $counter, confettiSize: 20, rainHeight: 750, radius: 400)
    }
}

#Preview {
    @StateObject var userService = UserController()
    @StateObject var settingsService = SettingsService()
    
    return BillsView()
        .environmentObject(userService)
        .environmentObject(settingsService)
}


