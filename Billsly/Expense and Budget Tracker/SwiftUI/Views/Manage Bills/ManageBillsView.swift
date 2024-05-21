//
//  ManageBillsView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/6/24.
//

import SwiftUI

struct ManageBillsView: View {
    @EnvironmentObject var userService: UserController
    @Binding var billList: [Bill]
    
    var body: some View {
        List(billList, id: \.identifier) { bill in
            HStack {
                VStack(alignment: .leading) {
                    Text(bill.name)
                        .foregroundStyle(.primary)
                    Text("Due: " + userService.mediumDf.string(from: bill.dueByDate))
                        .foregroundStyle(.primary)
                }
                Spacer()
                Text("\(bill.dollarAmount as NSNumber, formatter: userService.currencyNf)")
                    .foregroundStyle(.primary)
            }
        }
    }
}
