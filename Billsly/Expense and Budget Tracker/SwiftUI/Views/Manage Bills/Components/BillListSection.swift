//
//  BillListSection.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/8/24.
//

import SwiftUI
import SwiftData

struct BillListSection: View {
    @EnvironmentObject var userService: UserController
    @EnvironmentObject var billService: BillService
    @Environment(\.modelContext) var context
    @State private var showEditBill = false
    @State private var tappedBill: NewBill?
    @Binding var billListType: BillSelection
    @Binding var expandListView: Bool
    @Binding var billList: [NewBill]
    @Binding var counter: Int
    @State private var showingDeleteConfirmation: Bool = false
    
    @Query(sort: \NewBill.dueByDate, order: .forward) var allBills: [NewBill]
    
    @Query(filter: #Predicate<NewBill> { bill in
        bill.hasBeenPaid == false
    }, sort: \NewBill.dueByDate, order: .forward) var unpaidBills: [NewBill]
    
    @Query(filter: #Predicate<NewBill> { bill in
        bill.hasBeenPaid == true
    }, sort: \NewBill.dueByDate, order: .forward) var paidBills: [NewBill]
    
    var body: some View {
        Section {
            if getCurrentList(selection: billListType).isEmpty {
                switch billListType {
                case .unpaid:
                    ContentUnavailableView(billService.unpaidBillsEmptyString, systemImage: "dollarsign.circle")
                case .all:
                    ContentUnavailableView(billService.allBillsEmptyString, systemImage: "dollarsign.circle")
                case .paid:
                    ContentUnavailableView(billService.paidBillsEmptyString, systemImage: "dollarsign.circle")
                }
            } else {
                List(getCurrentList(selection: billListType), id: \.identifier) { bill in
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
                    .swipeActions(allowsFullSwipe: false) {
                        Button(bill.hasBeenPaid ? "Mark unpaid" : "Mark paid") {
                            if bill.hasBeenPaid == false {
                                counter += 1
                            }
                            billService.updatePaidBillStatus(bill: bill, context: context)
                        }
                        .tint(.indigo)
                        
                        Button("Delete") {
                            tappedBill = bill
                            showingDeleteConfirmation.toggle()
                        }
                        .tint(.red)
                    }
                }
                .listStyle(.plain)
            }
        } header: {
            HStack {
                Text(billListType.rawValue)
                Spacer()
                Button {
                    billList = getCurrentList(selection: billListType)
                    expandListView.toggle()
                } label: {
                    Image(systemName: "rectangle.expand.vertical")
                }
            }
            .padding(.horizontal, 12)
        }
        .cornerRadius(12)
        .modifier(DeleteAlertViewModifier(showingAlert: $showingDeleteConfirmation, bill: tappedBill))
        .fullScreenCover(isPresented:$showEditBill) {
            EditAddBillView(isEdit: true, bill: tappedBill)
        }
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
