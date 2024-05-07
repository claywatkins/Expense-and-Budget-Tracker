//
//  HomeScreenHeaderView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/7/24.
//

import SwiftUI
import FluidGradient

struct HomeScreenHeaderView: View {
    @EnvironmentObject var userService: UserController
    @Binding var showingPaidBills: Bool
    var horizontalPadding: CGFloat = 12
    
    var body: some View {
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
                                .foregroundStyle(.thinMaterial)
                                .cornerRadius(12)
                                .modifier(ShadowViewModifier())
                                .overlay {
                                    VStack(alignment: .center, spacing: 9) {
                                        Text("Expenses tracked this month:")
                                            .foregroundStyle(.primary)
                                            .multilineTextAlignment(.center)
                                        Text("\(userService.unpaidBills.count)")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.primary)
                                    }
                                }

                            Rectangle()
                                .foregroundStyle(.thinMaterial)
                                .cornerRadius(12)
                                .modifier(ShadowViewModifier())
                                .overlay {
                                    VStack(alignment: .center, spacing: 9) {
                                        Text("Bills left to pay this month:")
                                            .multilineTextAlignment(.center)
                                            .foregroundStyle(.primary)
                                        Text("\(userService.unpaidBills.count)")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.primary)
                                    }
                                }
                        }
                        
                        Spacer()
                        HStack {
                            Spacer()
                            Text(userService.mediumDf.string(from: Date.now))
                                .foregroundStyle(.primary)
                            
                        }
                    }
                    .padding(12)
                }
            }
            .foregroundStyle(.secondary)
            .cornerRadius(12)
            .frame(height: 220)
            .modifier(ShadowViewModifier())
        
        HStack {
            Button {
                showingPaidBills.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.secondary)
                    .overlay {
                        Text("Add new expense")
                            .foregroundStyle(Color(.label))
                    }
                    .frame(height: 50)
                    .modifier(ShadowViewModifier())
            }
            
            Button {
                showingPaidBills.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.secondary)
                    .overlay {
                        Text("I paid a bill")
                            .foregroundStyle(Color(.label))
                    }
                    .frame(height: 50)
                    .modifier(ShadowViewModifier())
            }
        }
    }
}

#Preview {
    @StateObject var userService = UserController()
    
    return HomeScreenHeaderView(showingPaidBills: .constant(false))
        .environmentObject(userService)
}
