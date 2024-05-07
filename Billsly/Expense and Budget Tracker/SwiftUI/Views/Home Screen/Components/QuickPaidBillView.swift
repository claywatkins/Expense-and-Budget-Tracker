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
        ScrollView {
            VStack(spacing: 30) {
                Text("What bill did you pay?")
                    .font(.title2)
                    .foregroundStyle(.primary)
                
                Picker("What bill did you pay?", selection: $selectedBill) {
                    Text("Choose a bill").tag(nil as Bill?)
                    ForEach(userService.unpaidBills, id: \.self) { bill in
                        Text(bill.name)
                            .tag(bill as Bill?)
                    }
                }
                
                Button {
                    if let selectedBill = selectedBill {
                        userService.updateBillHasBeenPaid(bill: selectedBill)
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
