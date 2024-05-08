//
//  HomeScreenView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 4/19/24.
//

import SwiftUI

struct HomeScreenView: View {
    @EnvironmentObject var userService: UserController
    @State private var showingPaidBills = false
    @State private var presentationDetent = PresentationDetent.fraction(0.3)
    @State private var colors: [Color] = []
    var horizontalPadding: CGFloat = 12
    
    var body: some View {
        VStack(spacing: 20) {
            HomeScreenHeaderView(colors: $colors, showingPaidBills: $showingPaidBills)
                .environmentObject(userService)
            HomeScreenListView(headerText: "Your next few bills at a glance")
                .environmentObject(userService)
            HomeScreenListView(headerText: "Your last few expenses at a glance")
                .environmentObject(userService)
            Spacer()
        }
        .padding(.horizontal, horizontalPadding)
        .background(.quaternary)
        .sheet(isPresented: $showingPaidBills) {
            QuickPaidBillView()
                .environmentObject(userService)
                .presentationDetents(
                    [.fraction(0.3)],
                    selection: $presentationDetent
                )
        }
        .task {
            await userService.loadDefaultCategories()
            self.colors = await userService.getColors()
//            await userService.generateTestBills()
        }
        .onAppear {
            userService.loadBillData()
            userService.loadUsername()
        }
    }
}

#Preview {
    @StateObject var userService = UserController()
    
    return HomeScreenView()
        .environmentObject(userService)
}
