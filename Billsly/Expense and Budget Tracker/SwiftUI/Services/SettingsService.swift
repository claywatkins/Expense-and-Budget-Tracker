//
//  SettingsService.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/7/24.
//

import Foundation
import SwiftUI

class SettingsService: ObservableObject {
    @AppStorage("username") var username: String = ""
    let appURLForSharing = URL(string: "https://apps.apple.com/us/app/billsly/id1560270556")!
    
    var appVersionString: String {
        if let appVersion = UIApplication.appVersion {
            return "Billsly App version \(appVersion)"
        } else {
            return ""
        }
    }
    
    @AppStorage("calendarColor") var calendarColor: Color = .blue
    @AppStorage("currentDayColor") var currendDayColor: Color = .red
}
