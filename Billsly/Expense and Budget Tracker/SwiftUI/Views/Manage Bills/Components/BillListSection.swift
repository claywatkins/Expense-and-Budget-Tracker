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
    @State private var billList: [Bill] = []
    @State private var showEditBill = false
    @State private var tappedBill: Bill?
    @Binding var billType: BillSelection
    @Binding var expandListView: Bool
    
    @Query(sort: \NewBill.dueByDate, order: .forward) var allBills: [NewBill]
    
    @Query(filter: #Predicate<NewBill> { bill in
        bill.hasBeenPaid == false
    }, sort: \NewBill.dueByDate, order: .forward) var unpaidBills: [NewBill]

    @Query(filter: #Predicate<NewBill> { bill in
        bill.hasBeenPaid == true
    }, sort: \NewBill.dueByDate, order: .forward) var paidBills: [NewBill]
    
    @State var currentList: [NewBill] = []
    
    var body: some View {
        Section {
            List(currentList, id: \.identifier) { bill in
                Button {
                    showEditBill.toggle()
                    //                    tappedBill = bill
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
            getCurrentList(selection: billType)
        }
        .onChange(of: billType) {
           getCurrentList(selection: billType)
        }
        .fullScreenCover(isPresented:$showEditBill) {
            EditAddBillView(isEdit: true, bill: tappedBill)
        }
    }
    
    func getCurrentList(selection: BillSelection) {
        switch selection {
        case .unpaid:
            currentList = unpaidBills
        case .all:
            currentList = allBills
        case .paid:
            currentList = paidBills
        }
    }
}
