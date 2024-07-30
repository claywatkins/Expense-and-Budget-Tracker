//
//  MainView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/6/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var userService: UserController
    @EnvironmentObject var settingsService: SettingsService
    @State private var selectedIndex = 0
    
    @Environment (\.modelContext) var context
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            HomeScreenView()
                .environmentObject(userService)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            NavigationStack() {
                BillsView()
                    .environmentObject(userService)
                    .environmentObject(settingsService)
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
    }
}
