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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Text(userService.username == nil ?
                         "Welcome to Billsly!" : "Welcome, \(userService.username)!")
                        .font(.title)
                }
                .padding(.horizontal, horizontalPadding)
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
                    .frame(height: 250)
                    .padding(.horizontal, horizontalPadding)
                
                HStack {
                    Button {
                        
                    } label: {
                        
                    }
                    
                    Button {
                        
                    } label: {
                        
                    }
                }
                
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
    HomeScreenView()
}
