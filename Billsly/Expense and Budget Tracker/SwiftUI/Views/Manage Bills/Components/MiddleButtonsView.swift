//
//  MiddleButtonsView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/21/24.
//

import SwiftUI

struct MiddleButtonsView: View {
    @Binding var showingAddBill: Bool
    @Binding var showingPaidBills: Bool
    
    var body: some View {
        HStack {
            Button {
                showingAddBill.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.secondary)
                    .overlay {
                        Text("Add a bill")
                            .foregroundStyle(Color(.label))
                    }
                    .frame(height: 50)
                    .modifier(ShadowViewModifier())
            }
            
            Button {
                showingPaidBills.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.secondary)
                    .overlay {
                        Text("I paid a bill")
                            .foregroundStyle(Color(.label))
                    }
                    .frame(height: 50)
                    .modifier(ShadowViewModifier())
            }
        }
    }
}

#Preview {
    MiddleButtonsView(showingAddBill: .constant(false),
                      showingPaidBills: .constant(false))
}
