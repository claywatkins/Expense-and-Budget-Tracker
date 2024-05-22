//
//  BillListSection.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/8/24.
//

import SwiftUI

struct BillListSection: View {
    @EnvironmentObject var userService: UserController
    @State private var billList: [Bill] = []
    @State private var showEditBill = false
    @State private var tappedBill: Bill?
    @Binding var billType: BillSelection
    @Binding var expandListView: Bool
    
    var body: some View {
        Section {
            List(billList, id: \.identifier) { bill in
                Button {
                    showEditBill.toggle()
                    tappedBill = bill
                } label: {
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
            .listStyle(.plain)
        } header: {
            HStack {
                Text(billType.rawValue)
                Spacer()
                Button {
                    userService.currentList = billList
                    expandListView.toggle()
                } label: {
                    Image(systemName: "rectangle.expand.vertical")
                }
            }
            .padding(.horizontal, 12)
        }
        .cornerRadius(12)
        .onAppear {
            billList = userService.getCorrectList(selection: billType)
        }
        .onChange(of: billType) {
            billList = userService.getCorrectList(selection: billType)
        }
        .fullScreenCover(isPresented:$showEditBill) {
            EditAddBillView(isEdit: true, bill: tappedBill)
        }
    }
}
