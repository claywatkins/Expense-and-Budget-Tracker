//
//  ManageBillsView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/6/24.
//

import SwiftUI
import SwiftData
import ConfettiSwiftUI

struct ManageBillsView: View {
    @EnvironmentObject var userService: UserController
    @EnvironmentObject var billService: BillService
    @Environment(\.modelContext) var context
    @State private var showingDeleteConfirmation: Bool = false
    @State private var selectedBill: NewBill?
    @Binding var counter: Int
    
    @Query(sort: \NewBill.dueByDate, order: .forward) var allBills: [NewBill]
    
    @Query(filter: #Predicate<NewBill> { bill in
        bill.hasBeenPaid == false
    }, sort: \NewBill.dueByDate, order: .forward) var unpaidBills: [NewBill]
    
    @Query(filter: #Predicate<NewBill> { bill in
        bill.hasBeenPaid == true
    }, sort: \NewBill.dueByDate, order: .forward) var paidBills: [NewBill]
    
    var body: some View {
        List(getCurrentList(selection: billService.billListType), id: \.identifier) { bill in
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
            .swipeActions(allowsFullSwipe: false) {
                Button(bill.hasBeenPaid ? "Mark unpaid" : "Mark paid") {
                    if bill.hasBeenPaid == false {
                        counter += 1
                        billService.totalBillsPaid += 1
                    }
                    billService.updatePaidBillStatus(bill: bill, context: context)
                }
                .tint(.indigo)
                
                Button("Delete") {
                    selectedBill = bill
                    showingDeleteConfirmation.toggle()
                }
                .tint(.red)
            }
        }
        .modifier(DeleteAlertViewModifier(showingAlert: $showingDeleteConfirmation, bill: selectedBill))
        .confettiCannon(counter: $counter, confettiSize: 20, rainHeight: 750, radius: 400)
    }
    
    private func getCurrentList(selection: BillSelection) -> [NewBill] {
        switch selection {
        case .unpaid:
            return unpaidBills
        case .all:
            return allBills
        case .paid:
            return paidBills
        }
    }
}
