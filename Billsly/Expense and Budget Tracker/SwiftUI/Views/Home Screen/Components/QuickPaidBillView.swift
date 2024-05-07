//
//  QuickPaidBillView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/7/24.
//

import SwiftUI

struct QuickPaidBillView: View {
    @EnvironmentObject var userService: UserController
    @Environment(\.dismiss) var dismiss
    @State private var selectedBill: Bill?
    
    var body: some View {
        VStack(spacing: 40) {
            Text("What bill did you pay?")
                .font(.title2)
                .foregroundStyle(.primary)
            
            if let selectedBill = selectedBill {
                Picker("What bill did you pay?", selection: $selectedBill) {
                    ForEach(userService.unpaidBills, id: \.identifier) { bill in
                        Text(bill.name)
                    }
                }
                
                Button {
                    userService.updateBillHasBeenPaid(bill: selectedBill)
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
        }
        .padding()
        .onAppear {
            if let firstBill = userService.userBills.first {
                self.selectedBill = firstBill
            }
        }
    }
}
