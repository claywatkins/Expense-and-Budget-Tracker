//
//  App.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/1/24.
//

import SwiftUI
import SwiftData

@main
struct Billsly: App {
    @StateObject var userService = UserController()
    @StateObject var settingsService = SettingsService()
    @StateObject var billService = BillService()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(userService)
                .environmentObject(settingsService)
                .environmentObject(billService)
        }
        .modelContainer(for: NewBill.self)
    }
}
