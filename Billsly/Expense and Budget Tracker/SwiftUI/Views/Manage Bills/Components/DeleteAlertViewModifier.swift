//
//  DeleteAlertViewModifier.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 8/3/24.
//

import SwiftUI

struct DeleteAlertViewModifier: ViewModifier {
    @EnvironmentObject var billService: BillService
    @Environment(\.modelContext) var context
    @Binding var showingAlert: Bool
    var bill: NewBill?
    
    func body(content: Content) -> some View {
        content
            .alert("Are you sure you want to delete this bill?", isPresented: $showingAlert) {
                Button("Delete", role: .destructive) {
                    if let bill = bill {
                        billService.deleteBill(bill: bill, context: context)
                    }
                }
                
                Button("Cancel", role: .cancel) {}
            }
    }
}
