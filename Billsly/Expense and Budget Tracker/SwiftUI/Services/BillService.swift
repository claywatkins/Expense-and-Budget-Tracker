//
//  BillService.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 7/30/24.
//

import SwiftUI
import SwiftData
import UserNotifications

enum BillSelection: String, CaseIterable {
    case unpaid = "Unpaid Bills"
    case all = "All Bills"
    case paid = "Paid Bills"
}

enum BillFrequency: String, CaseIterable {
    case monthly = "Monthly"
    case quarterly = "Quarterly"
    case annually = "Annually"
}

enum BillCategories: String, CaseIterable {
    case subscription = "Subscription"
    case utility = "Utility"
    case rent = "Rent"
    case mortgage = "Mortgage"
    case loan = "Loan"
    case creditCard = "Credit Card"
    case insurance = "Insurance"
    case carLoan = "Car Loan"
    case other = "Other"
}

@MainActor
class BillService: ObservableObject {
    
    @AppStorage("currentMonthInt") var currentMonthInt: Int = Date().monthInt    
    @AppStorage("billListType") var billListType: BillSelection = .unpaid
    @AppStorage("totalBillsPaid") var totalBillsPaid: Int = 0
    
    @Published var billWasUpdatedTrigger: Bool = false
    
    var unpaidBillsEmptyString = "There are no bills left to pay this month"
    var paidBillsEmptyString = "You do not have any bills paid yet this month"
    var allBillsEmptyString = "You have not added any bills yet"
    
    func getBillsForDay(allBills: [NewBill], dayInt: Int) -> [NewBill?] {
        let mappedBills = allBills.map{
            var bill: NewBill?
            if $0.dueByDate.dayInt == dayInt {
                bill = $0
            }
            return bill
        }
        return mappedBills
    }
    
    func getProgressFloat(paidBills: [NewBill], allBills: [NewBill]) -> CGFloat {
        if paidBills.count == 0 || allBills.count == 0 {
            return 0
        }
        let paidBillsCount = CGFloat(paidBills.count)
        let totalBillsCount = CGFloat(allBills.count)
        return paidBillsCount/totalBillsCount.rounded(.up)
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
        currentMonthInt = Date().monthInt
        if determineIfResetIsNeeded(allBills: allBills) {
            await resetBills(paidBills: paidBills, context: context)
            await moveBillsToNextMonth(allBills: allBills, context: context)
        }
    }
    
    func resetBills(paidBills: [NewBill], context: ModelContext) async {
        for bill in paidBills {
            bill.monthCount -= 1
            if bill.monthCount == 0 {
                updatePaidBillStatus(bill: bill, context: context)
            }
        }
        try? context.save()
    }
    
    private func moveBillsToNextMonth(allBills: [NewBill], context: ModelContext) async {        
        for bill in allBills {
            let dateNum = bill.dueByDate.dayInt
            var dateComponents = DateComponents()
            dateComponents.month = currentMonthInt
            if dateNum < 30 && currentMonthInt != 3{
                let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
                bill.dueByDate = moveForwardOneMonth
                try? context.save()
                continue
            }
            
            switch currentMonthInt {
            case 1, 2, 4, 6, 8, 9, 11:
                dateComponents.month = currentMonthInt
                let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
                bill.dueByDate = moveForwardOneMonth
                try? context.save()
                continue
                
            case 5, 7, 10, 12:
                if bill.isOn30th == true {
                    dateComponents.month = currentMonthInt
                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
                    bill.dueByDate = moveForwardOneMonth
                    try? context.save()
                    continue
                } else {
                    dateComponents.month = currentMonthInt
                    dateComponents.day = 1
                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
                    bill.dueByDate = moveForwardOneMonth
                    try? context.save()
                    continue
                }
                
            case 3:
                if dateNum < 28 {
                    dateComponents.month = currentMonthInt
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
                    dateComponents.month = currentMonthInt
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
    
    func updatePaidBillStatus(bill: NewBill, context: ModelContext) {
        bill.hasBeenPaid.toggle()
        let frequency = BillFrequency(rawValue: bill.frequency)
        switch frequency {
        case .monthly:
            bill.monthCount = 1
        case .quarterly:
            bill.monthCount = 3
        case .annually:
            bill.monthCount = 12
        case nil:
            bill.monthCount = 1
        }
        try? context.save()
    }
    
    func saveBill(bill: NewBill, context: ModelContext) {
        context.insert(bill)
    }
    
    func deleteBill(bill: NewBill, context: ModelContext) {
        context.delete(bill)
    }
    
    func scheduleNotifications(with unpaidBills: [NewBill]) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        for bill in unpaidBills {
            if currentMonthInt == bill.dueByDate.monthInt {
                let content = UNMutableNotificationContent()
                content.title = "Upcoming bill due!"
                content.body = "Don't forget to pay \(bill.name) tomorrow and mark it as paid in billsly!"
                content.sound = UNNotificationSound.default
                
                let dayInt = bill.dueByDate.dayInt
                
                var dateComponents = DateComponents()
                if dayInt == 1 {
                    dateComponents.calendar = Calendar.current
                    dateComponents.timeZone = TimeZone.current
                    dateComponents.day = dayInt
                    dateComponents.hour = 11
                } else {
                    dateComponents.calendar = Calendar.current
                    dateComponents.timeZone = TimeZone.current
                    dateComponents.day = dayInt - 1
                    dateComponents.hour = 11
                }
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let request = UNNotificationRequest(identifier: bill.identifier,
                                                    content: content,
                                                    trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}

