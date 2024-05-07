//
//  SettingsFooter.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/7/24.
//

import SwiftUI

struct SettingsFooter: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Crafted with")
            Image(systemName: "heart.fill")
                .foregroundStyle(Color(uiColor: UIColor(red: 254,
                                                        green: 95,
                                                        blue: 85)))
            Text("by")
            Button("@CaptainnClayton") {
                let twitterHandle = "CaptainnClayton"
                let appURL = URL(string: "twitter://user?screen_name=\(twitterHandle)")!
                let webURL = URL(string: "https://twitter.com/\(twitterHandle)")!
                
                let application = UIApplication.shared
                
                if application.canOpenURL(appURL as URL) {
                    application.open(appURL)
                } else {
                    application.open(webURL)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    SettingsFooter()
}
