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
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }
    var nf: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        return nf
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Rectangle()
                .overlay {
                    ZStack {
                        FluidGradient(blobs: userService.getColors(),
                                      speed: 0.25,
                                      blur: 0.75)
                        
                        VStack {
                            HStack {
                                Text("Billsly")
                                    .font(.title2)
                                    .foregroundStyle(.primary)
                                Spacer()
                            }
                            HStack {
                                Text(userService.username == nil ? "Welcome back!" : "Welcome back, \(userService.username)!")
                                    .font(.title2)
                                    .foregroundStyle(.primary)
                                Spacer()
                            }
                            Spacer()
                            
                            HStack {
                                Rectangle()
                                    .foregroundStyle(.background)
                                    .opacity(0.6)
                                    .cornerRadius(12)
                                    .overlay {
                                        VStack(alignment: .center, spacing: 9) {
                                            Text("Expenses tracked this month:")
                                                .foregroundStyle(.primary)
                                                .multilineTextAlignment(.center)
                                            Text("\(userService.userBills.count)")
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundStyle(.primary)
                                        }
                                    }
                                Rectangle()
                                    .foregroundStyle(.background)
                                    .opacity(0.6)
                                    .cornerRadius(12)
                                    .overlay {
                                        VStack(alignment: .center, spacing: 9) {
                                            Text("Bills left to pay this month:")
                                                .multilineTextAlignment(.center)
                                                .foregroundStyle(.primary)
                                            Text("\(userService.userBills.count)")
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundStyle(.primary)
                                        }
                                    }
                            }
                            
                            Spacer()
                            HStack {
                                Spacer()
                                Text(df.string(from: Date.now))
                                    .foregroundStyle(.primary)
                                
                            }
                        }
                        .padding(12)
                    }
                }
                .foregroundStyle(.secondary)
                .cornerRadius(12)
                .frame(height: 220)
                .padding(.horizontal, horizontalPadding)
                .modifier(ShadowViewModifier())
            
            HStack {
                Button {
                    showingManageBills.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.secondary)
                        .overlay {
                            Text("Add new expense")
                                .foregroundStyle(.background)
                        }
                        .frame(height: 50)
                }
                .modifier(ShadowViewModifier())
                
                Button {
                    showingManageBills.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.secondary)
                        .overlay {
                            Text("I paid a bill")
                                .foregroundStyle(.background)
                        }
                        .frame(height: 50)
                }
                .modifier(ShadowViewModifier())
            }
            .padding(.horizontal, horizontalPadding)
            
            VStack {
                HStack {
                    Text("Your last few expenses at a glance")
                        .font(.subheadline)
                        .foregroundStyle(.foreground)
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
                .cornerRadius(12)
                .modifier(ShadowViewModifier())
            }
            
            .padding(.horizontal, horizontalPadding)
            
            VStack {
                HStack {
                    Text("Your next few bills at a glance")
                        .font(.subheadline)
                        .foregroundStyle(.foreground)
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
                .cornerRadius(12)
                .modifier(ShadowViewModifier())
            }
            .padding(.horizontal, horizontalPadding)
            
            Spacer()
            
        }
        .background(.quaternary)
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

#Preview {
    @StateObject var userService = UserController()
    
    return HomeScreenView()
        .environmentObject(userService)
}
