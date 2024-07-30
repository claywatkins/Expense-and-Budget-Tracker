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
    @State private var progressFloat: CGFloat = 0.23
    @State var counter: Int = 0
    var horizontalPadding: CGFloat = 12
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if userService.hasBeenConverted == false {
                    ProgressView {
                        Text("Converting saved data")
                    }
                } else {
                    HomeScreenHeaderView(colors: $colors, showingPaidBills: $showingPaidBills)
                        .environmentObject(userService)
                    HomeScreenListView(headerText: "Your next few bills at a glance")
                        .environmentObject(userService)
                    CircularBillProgressView(colors: colors)
                        .environmentObject(userService)
                }
            }
            .padding(.horizontal, horizontalPadding)
            .task {
                await userService.loadDefaultCategories()
                self.colors = await userService.getColors()
                await userService.generateTestBills()
            }
            .onAppear {
                userService.loadUsername()
            }
            .task {
                if userService.hasBeenConverted == false {
                    await userService.convertToSwiftData()
                }
            }
        }
        .background(.quaternary)
    }
}

#Preview {
    @StateObject var userService = UserController()
    
    return HomeScreenView()
        .environmentObject(userService)
}
