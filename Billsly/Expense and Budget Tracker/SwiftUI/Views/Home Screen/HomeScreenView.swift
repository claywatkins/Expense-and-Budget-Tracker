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
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HomeScreenHeaderView(colors: $colors, showingPaidBills: $showingPaidBills)
                    .environmentObject(userService)
                HomeScreenListView(headerText: "Your next few bills at a glance")
                    .environmentObject(userService)
                CircularBillProgressView(colors: colors)
                    .environmentObject(userService)
            }
            .padding(.horizontal, horizontalPadding)
            .task {
                await userService.loadDefaultCategories()
//                await userService.generateTestBills()
                await userService.loadBillData()
                await userService.checkForExistingBills()
                self.colors = await userService.getColors()
                await userService.loadUsername()
                
                if userService.hasBeenConverted == false {
                    
                    for bill in userService.userBills {
                            let newBill = NewBill(identifier: bill.identifier,
                                                  name: bill.name,
                                                  dollarAmount: bill.dollarAmount,
                                                  dueByDate: bill.dueByDate,
                                                  hasBeenPaid: bill.hasBeenPaid,
                                                  category: bill.category.name,
                                                  isOn30th: bill.isOn30th,
                                                  isAutopay: false,
                                                  frequency: "monthly")

                            context.insert(newBill)
                        }
                    
                    userService.hasBeenConverted = true
                    userService.showingConversion = false
                }

            }
            .fullScreenCover(isPresented: $userService.showingConversion) {
                ProgressView {
                    Text("Converting to Swift Data.. This may take a moment")
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
