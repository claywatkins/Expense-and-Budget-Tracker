//
//  HomeScreenView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 4/19/24.
//

import SwiftUI
import FluidGradient

struct HomeScreenView: View {
    @EnvironmentObject var userService: UserController
    @State private var showingManageBills = false
    @State private var presentationDetent = PresentationDetent.medium
    var horizontalPadding: CGFloat = 12
    var df: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        return df
    }
    var nf: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        return nf
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 12)
                    .overlay {
                        ZStack {
                            FluidGradient(blobs: userService.getColors(),
                                          speed: 0.35,
                                          blur: 0.65)
                            
                            Text("Test")
                                .font(.title.bold())
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(height: 220)
                    .padding(.horizontal, horizontalPadding)
                
                HStack {
                    Button {
                        showingManageBills.toggle()
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.cyan.gradient)
                            .overlay {
                                Text("Manage Bills")
                            }
                            .frame(height: 50)
                    }
                    
                    
                    Button {
                        showingManageBills.toggle()
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.orange.gradient)
                            .overlay {
                                Text("Manage Bills")
                            }
                            .frame(height: 50)
                    }
                }
                .padding(.horizontal, horizontalPadding)
                
                VStack {
                    HStack {
                        Text("Your next few bills at a glance")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        Spacer()
                        }
                    List(userService.userBills.prefix(3), id: \.identifier) { bill in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(bill.name)
                                Text("Due: " + df.string(from: bill.dueByDate))
                            }
                            Spacer()
                            Text("\(bill.dollarAmount as NSNumber, formatter: nf)")
                        }
                    }
                    .listStyle(.inset)
                }
                
                .padding(.horizontal, horizontalPadding)
                
                VStack {
                    HStack {
                        Text("Your next few bills at a glance")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        Spacer()
                        }
                    List(userService.userBills.prefix(3), id: \.identifier) { bill in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(bill.name)
                                Text("Due: " + df.string(from: bill.dueByDate))
                            }
                            Spacer()
                            Text("\(bill.dollarAmount as NSNumber, formatter: nf)")
                        }
                    }
                    .listStyle(.inset)
                }
                
                .padding(.horizontal, horizontalPadding)
                
                Spacer()
                
                
            }
            .sheet(isPresented: $showingManageBills) {
                    ManageBillsView()
                        .environmentObject(userService)
                        .presentationDetents(
                            [.medium, .large],
                            selection: $presentationDetent
                        )
            }
            .task {
                await userService.loadDefaultCategories()
                await userService.generateTestBills()
            }
        }
    }
}

#Preview {
    @StateObject var userService = UserController()
    
    return HomeScreenView()
        .environmentObject(userService)
}
