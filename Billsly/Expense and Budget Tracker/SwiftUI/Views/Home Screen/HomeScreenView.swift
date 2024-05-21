//
//  HomeScreenView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 4/19/24.
//

import SwiftUI
import ConfettiSwiftUI

struct HomeScreenView: View {
    @EnvironmentObject var userService: UserController
    @State private var showingPaidBills = false
    @State private var presentationDetent = PresentationDetent.fraction(0.3)
    @State private var colors: [Color] = []
    @State var counter: Int = 0
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
            QuickPaidBillView(counter: $counter)
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
        .confettiCannon(counter: $counter, confettiSize: 20, rainHeight: 750, radius: 400)
    }
}

#Preview {
    @StateObject var userService = UserController()
    
    return HomeScreenView()
        .environmentObject(userService)
}
