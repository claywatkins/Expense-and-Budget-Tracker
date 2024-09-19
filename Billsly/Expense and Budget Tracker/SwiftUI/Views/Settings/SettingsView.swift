//
//  SettingsView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/7/24.
//

import SwiftUI
import StoreKit
import MessageUI

struct SettingsView: View {
    @EnvironmentObject var userService: UserController
    @EnvironmentObject var settingsService: SettingsService
    @Environment(\.requestReview) var requestReview
    @State private var username: String = ""
    @State private var showingActivitySheet: Bool = false
    @State private var showingMailSheet: Bool = false
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var showingConfirmation: Bool = false
    
    var body: some View {
        List {
            Section {
                HStack {
                    TextField(settingsService.username.isEmpty ? "Enter your name here" : "Hello, \(settingsService.username)", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button {
                        settingsService.username = username
                        showingConfirmation.toggle()
                    } label : {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.secondary)
                            .overlay {
                                Text("Save")
                                    .foregroundStyle(Color(.label))
                            }
                            .frame(width: 80)
                    }
                }
            } header: {
                Text("User Information")
            }
            
            Section {
                VStack(spacing: 12) {
                    LabeledContent("Calendar Color") {
                        ColorPicker("",
                                    selection: $settingsService.calendarColor,
                                    supportsOpacity: false)
                    }
                    Divider()
                    LabeledContent("Current Day Color") {
                        ColorPicker("",
                                    selection: $settingsService.currendDayColor,
                                    supportsOpacity: false)
                    }
                }
            } header: {
                Text("App Settings")
            }
            
            Section {
                SettingsSupportCell(image: "hand.thumbsup",
                                    text: "Leave a rating",
                                    subtext: "Support my app by leaving a review!") {
                    requestReview()
                }
                
                SettingsSupportCell(image: "paperplane",
                                    text: "Share the app",
                                    subtext: "Know someone with bills? Send this app their way!"){
                    showingActivitySheet.toggle()
                }
                            
                SettingsSupportCell(image: "envelope",
                                    text: "Send feedback",
                                    subtext: "Email thoughts, bugs, or questions.") {
                    showingMailSheet.toggle()
                }

                SettingsSupportCell(image: "cup.and.saucer",
                                    text: "Tip jar",
                                    subtext: "Show some love and support an indie dev's coffee addiction!") {
                    print("test")
                }

            } header: {
                Text("Support the Developer")
            }
            
            SettingsFooter()
                .environmentObject(settingsService)
        }
        .sheet(isPresented: $showingActivitySheet) {
            ActivityView(url: settingsService.appURLForSharing)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showingMailSheet) {
            MailView(result: $result)
        }
        .alert("Name updated!",
               isPresented: $showingConfirmation) {
            Button("Ok") {}
        }
    }
}

#Preview {
    @StateObject var userService = UserController()
    @StateObject var settingsService = SettingsService()
    
    return SettingsView()
        .environmentObject(userService)
        .environmentObject(settingsService)
}
