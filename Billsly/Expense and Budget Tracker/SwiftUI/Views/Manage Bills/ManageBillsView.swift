//
//  ManageBillsView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/6/24.
//

import SwiftUI

struct ManageBillsView: View {
    
    @EnvironmentObject var userService: UserController
    
    var body: some View {
        List(userService.userBills, id: \.identifier) { bill in
            HStack {
                VStack {
                    Text(bill.name)
                    Text(userService.df.string(from: bill.dueByDate))
                }
                
                Spacer()
                
                VStack {
                    Text(String(bill.dollarAmount))
                }
            }
        }
    }
}
