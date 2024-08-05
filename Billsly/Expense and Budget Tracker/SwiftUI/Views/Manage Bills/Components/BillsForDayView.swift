//
//  BillsForDayView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/21/24.
//

import SwiftUI

struct BillsForDayView: View {
    @EnvironmentObject var userService: UserController
    @EnvironmentObject var billService: BillService
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    let bills: [NewBill?]
    
    var body: some View {
        VStack {
            List {
                ForEach(bills, id: \.?.identifier) { bill in
                    if let bill = bill {
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
        }
    }
}

#Preview {
    @StateObject var userService = UserController()
    
    return BillsForDayView(bills: [nil])
            .environmentObject(userService)
}
