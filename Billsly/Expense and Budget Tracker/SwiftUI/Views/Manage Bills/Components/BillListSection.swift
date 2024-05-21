//
//  BillListSection.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/8/24.
//

import SwiftUI

struct BillListSection: View {
    @EnvironmentObject var userService: UserController
    @State var billList: [Bill]
    @Binding var expandListView: Bool
    @Binding var date: Date
    var sectionTitle: String
    
    var body: some View {
        Section {
            List(billList, id: \.identifier) { bill in
                Button {
                    self.date = bill.dueByDate
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
                Text(sectionTitle)
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
    }
}
