//
//  HomeScreenListView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/7/24.
//

import SwiftUI
import SwiftData

struct HomeScreenListView: View {
    @EnvironmentObject var userService: UserController
    var headerText: String
    
    @Query(sort: \NewBill.dueByDate, order: .forward) var bills: [NewBill]
    
    var body: some View {
        VStack {
            HStack {
                Text(headerText)
                    .font(.subheadline)
                    .foregroundStyle(.foreground)
                Spacer()
            }
            List(bills.prefix(3), id: \.identifier) { bill in
                HStack {
                    VStack(alignment: .leading) {
                        Text(bill.name)
                        Text("Due: " + userService.mediumDf.string(from: bill.dueByDate))
                    }
                    Spacer()
                    Text("\(bill.dollarAmount as NSNumber, formatter: userService.currencyNf)")
                }
            }
            .listStyle(.inset)
            .cornerRadius(12)
            .modifier(ShadowViewModifier())
            .frame(height: 200)
        }
    }
}
