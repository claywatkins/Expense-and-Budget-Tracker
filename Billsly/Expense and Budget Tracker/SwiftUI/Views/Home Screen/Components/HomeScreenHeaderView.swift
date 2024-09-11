//
//  HomeScreenHeaderView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/7/24.
//

import SwiftUI
import FluidGradient
import SwiftData

struct HomeScreenHeaderView: View {
    @EnvironmentObject var userService: UserController
    @EnvironmentObject var settingsService: SettingsService
    @EnvironmentObject var billService: BillService
    @Binding var colors: [Color]
    @Binding var showingPaidBills: Bool
    var horizontalPadding: CGFloat = 12
    
    @Query(filter: #Predicate<NewBill> { bill in
        bill.hasBeenPaid == false
    }, sort: \NewBill.dueByDate, order: .forward) var unpaidBills: [NewBill]
    
    var body: some View {
        Rectangle()
            .overlay {
                ZStack {
                    FluidGradient(blobs: colors,
                                  speed: 0.25,
                                  blur: 0.75)
                    
                    VStack {
                        HStack {
                            Text("Billsly")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                        HStack {
                            if !settingsService.username.isEmpty {
                                Text("Welcome back, \(settingsService.username)!")
                                    .font(.title2)
                                    .foregroundStyle(.primary)
                            } else {
                                Text("Welcome to Billsly!")
                                    .font(.title2)
                                    .foregroundStyle(.primary)
                            }                                
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
                                        Text("Bills paid since you've started using Billsly:")
                                            .font(.subheadline)
                                            .minimumScaleFactor(0.75)
                                            .foregroundStyle(.primary)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 4)
                                        Text("\(billService.totalBillsPaid)")
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
                                            .font(.subheadline)
                                            .minimumScaleFactor(0.75)
                                            .multilineTextAlignment(.center)
                                            .foregroundStyle(.primary)
                                            .padding(.horizontal, 4)

                                        Text("\(unpaidBills.count)")
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
        
//        HStack {
//            Button {
//                showingPaidBills.toggle()
//            } label: {
//                RoundedRectangle(cornerRadius: 12)
//                    .foregroundStyle(.secondary)
//                    .overlay {
//                        Text("Add new expense")
//                            .foregroundStyle(Color(.label))
//                    }
//                    .frame(height: 50)
//                    .modifier(ShadowViewModifier())
//            }
//
//        }
    }
}

#Preview {
    @StateObject var userService = UserController()
    
    return HomeScreenHeaderView(colors: .constant([.red, .blue, .yellow]),
                                showingPaidBills: .constant(false))
        .environmentObject(userService)
}
