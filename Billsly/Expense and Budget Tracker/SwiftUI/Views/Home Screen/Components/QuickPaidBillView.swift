//
//  QuickPaidBillView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/7/24.
//

import SwiftUI
import SwiftData

struct QuickPaidBillView: View {
    @EnvironmentObject var userService: UserController
    @EnvironmentObject var billService: BillService
    @Environment(\.dismiss) var dismiss
    @State private var selectedBill: NewBill?
    @Binding var counter: Int
    
    @Environment(\.modelContext) var context
    
    @Query(filter: #Predicate<NewBill> { bill in
        bill.hasBeenPaid == false
    }, sort: \NewBill.dueByDate, order: .forward) var unpaidBills: [NewBill]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("What bill did you pay?")
                    .font(.title2)
                    .foregroundStyle(.primary)
                
                Picker("What bill did you pay?", selection: $selectedBill) {
                    Text("Choose a bill").tag(nil as NewBill?)
                    ForEach(unpaidBills, id: \.self) { bill in
                        Text(bill.name)
                            .tag(bill as NewBill?)
                    }
                }
                
                Button {
                    if let selectedBill = selectedBill {
                        billService.markBillAsPaid(bill: selectedBill, context: context)
                        counter += 1
                    }
                    dismiss()
                } label: {
                    Rectangle()
                        .foregroundStyle(.secondary)
                        .overlay {
                            Text("Paid!")
                                .foregroundStyle(.primary)
                        }
                        .cornerRadius(12)
                        .frame(height: 50)
                }
            }
            .padding()
        }
    }
}
