//
//  App.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/1/24.
//

import SwiftUI

@main
struct Billsly: App {
    
    @StateObject var userService = UserController()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(userService)
        }
    }
}
