//
//  BillService.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 7/30/24.
//

import SwiftUI
import SwiftData

@MainActor
class BillService: ObservableObject {
    
    @AppStorage("currentMonthInt") var currentMonthInt: Int = Date().monthInt
    
    var unpaidBillsEmptyString = "There are no bills left to pay this month"
    var paidBillsEmptyString = "You do not have any bills paid yet this month"
    var allBillsEmptyString = "You have not added any bills yet"

    func markBillAsPaid(bill: NewBill, context: ModelContext) {
        bill.hasBeenPaid = true
        try? context.save()
    }
    
    private func determineIfResetIsNeeded(allBills: [NewBill]) -> Bool {
        if let firstBill = allBills.first {
            let firstBillMonthInt = firstBill.dueByDate.monthInt
            if firstBillMonthInt != currentMonthInt {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func checkIfBillsShouldBeUpdated(paidBills: [NewBill], allBills: [NewBill], context: ModelContext) async {
        if determineIfResetIsNeeded(allBills: allBills) {
            currentMonthInt = Date().monthInt
            resetBills(paidBills: paidBills, context: context)
            moveBillsToNextMonth(allBills: allBills, context: context)
        }
    }
        
    private func resetBills(paidBills: [NewBill], context: ModelContext) {
        for bill in paidBills {
            bill.hasBeenPaid = false
            try? context.save()
        }
    }
    
    private func moveBillsToNextMonth(allBills: [NewBill], context: ModelContext) {
        guard let currentBillMonthDate = allBills.first?.dueByDate.monthInt else { return }
        let monthsToAdd = currentMonthInt - currentBillMonthDate
        
        for bill in allBills {
            let dateNum = bill.dueByDate.dayInt
            var dateComponents = DateComponents()
            dateComponents.month = monthsToAdd
            if dateNum < 30 && currentMonthInt != 3{
                let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
                bill.dueByDate = moveForwardOneMonth
                try? context.save()
                continue
            }

            switch currentMonthInt {
            case 1, 2, 4, 6, 8, 9, 11:
                dateComponents.month = monthsToAdd
                let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
                bill.dueByDate = moveForwardOneMonth
                try? context.save()
                continue

            case 5, 7, 10, 12:
                if bill.isOn30th == true {
                    dateComponents.month = monthsToAdd
                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
                    bill.dueByDate = moveForwardOneMonth
                    try? context.save()
                    continue
                } else {
                    dateComponents.month = monthsToAdd
                    dateComponents.day = 1
                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
                    bill.dueByDate = moveForwardOneMonth
                    try? context.save()
                    continue
                }

            case 3:
                if dateNum < 28 {
                    dateComponents.month = monthsToAdd
                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
                    bill.dueByDate = moveForwardOneMonth
                    try? context.save()
                    continue
                } else if dateNum == 28 {
                    if bill.isOn30th == true {
                        dateComponents.day = 2
                    } else {
                        dateComponents.day = 3
                    }
                    dateComponents.month = monthsToAdd
                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
                    bill.dueByDate = moveForwardOneMonth
                    try? context.save()
                    continue
                } else if dateNum == 29 {
                    if bill.isOn30th == true {
                        dateComponents.day = 1
                    } else {
                        dateComponents.day = 2
                    }
                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
                    bill.dueByDate = moveForwardOneMonth
                    try? context.save()
                    continue
                }

            default:
                fatalError()
            }
        }
    }
}

