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
            if firstBillMonthInt != Date().monthInt {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func checkIfBillsShouldBeUpdated(paidBills: [NewBill], allBills: [NewBill], context: ModelContext) async {
        if determineIfResetIsNeeded(allBills: allBills) {
            await resetBills(paidBills: paidBills, context: context)
            await moveBillsToNextMonth(allBills: allBills, context: context)
        }
    }
    
   private func resetBills(paidBills: [NewBill], context: ModelContext) async {
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
            let dayNum = bill.dueByDate.dayInt
            var newDayNum = 1
            
            switch bill.dueByDate.monthInt {
            case 1, 3, 5, 7, 8, 10, 12:
                if bill.dueByDate.monthInt == 1 && bill.isOn30th || bill.dueByDate.dayInt == 31 {
                    newDayNum = 28
                } else if dayNum == 31 {
                    newDayNum = bill.dueByDate.dayInt - 1
                } else {
                    newDayNum = bill.dueByDate.dayInt
                }
                
                bill.dueByDate = Calendar.current.date(from: .init(calendar: .current, year: Date().yearInt, month: Date().monthInt, day: newDayNum))!
                try? context.save()
                continue
                
            case 4, 6, 9, 11:
                if dayNum == 30 && !bill.isOn30th {
                    newDayNum = bill.dueByDate.dayInt + 1
                } else {
                    newDayNum = bill.dueByDate.dayInt
                }
                
                
//                let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
                bill.dueByDate = Calendar.current.date(from: .init(calendar: .current, year: Date().yearInt, month: Date().monthInt, day: newDayNum))!
                try? context.save()
                continue
                
            case 2:
                if dayNum == 28 && bill.isOn30th {
                    newDayNum = 30
                } else if dayNum == 28 {
                    newDayNum = 31
                } else {
                    newDayNum = bill.dueByDate.dayInt
                }

                bill.dueByDate = Calendar.current.date(from: .init(calendar: .current, year: Date().yearInt, month: Date().monthInt, day: newDayNum))!

                try? context.save()
                continue
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
    
    func checkForAutoPay(unpaidBills: [NewBill], context: ModelContext) {
        for bill in unpaidBills {
            if bill.isAutopay {
                if bill.dueByDate.dayInt == Date().dayInt {
                    bill.hasBeenPaid.toggle()
                    totalBillsPaid += 1
                }
            }
        }
    }
    
    func scheduleNotifications(with unpaidBills: [NewBill]) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        for bill in unpaidBills {
            if Date().monthInt == bill.dueByDate.monthInt {
                let content = UNMutableNotificationContent()
                content.title = "Upcoming bill due!"
                if bill.isAutopay {
                    content.body = "\(bill.name) is marked for autopay. The bill will automatically update on it's due date."
                } else {
                    content.body = "Don't forget to pay \(bill.name) tomorrow and mark it as paid in billsly!"
                }
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
                print("Request added! : \(request.identifier)")
            }
        }
    }
}

