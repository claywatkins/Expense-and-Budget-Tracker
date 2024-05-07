//
//  SettingsView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/7/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userService: UserController
    @State private var username: String = ""
    
    var body: some View {
        List {
            Section {
                HStack {
                    TextField((userService.username != nil ? "Your name is \(userService.username ?? "unknown")" : "Enter your name"), text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button {
                        userService.setUsername(username)
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
                    SettingsSupportCell(image: "hand.thumbsup",
                                        text: "Leave a rating",
                                        subtext: "Support my app by leaving a review!") {
                        
                    }
                    SettingsSupportCell(image: "paperplane",
                                        text: "Share the app",
                                        subtext: "Know someone with bills? Send this app their way!") {
                        
                    }

                    SettingsSupportCell(image: "envelope",
                                        text: "Send feedback",
                                        subtext: "Email thoughts, bugs, or questions.") {
                        
                    }
                    
                
            } header: {
                Text("Support the Developer")
            }
            
            SettingsFooter()
        }
    }
}

#Preview {
    @StateObject var userService = UserController()
    
    return SettingsView()
        .environmentObject(userService)
}
