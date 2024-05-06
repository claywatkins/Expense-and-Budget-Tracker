//
//  MainView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/6/24.
//

import SwiftUI

struct MainView: View {
    @State private var selectedIndex = 0
    @EnvironmentObject var userService: UserController
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            NavigationStack() {
                HomeScreenView()
                    .environmentObject(userService)
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)
        }
    }
}

#Preview {
    MainView()
}
