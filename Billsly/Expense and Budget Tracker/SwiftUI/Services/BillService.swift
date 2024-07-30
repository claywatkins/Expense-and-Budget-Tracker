//
//  BillService.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 7/30/24.
//

import SwiftUI
import SwiftData

class BillService: ObservableObject {
    @Query(sort: \NewBill.dueByDate, order: .forward) var allBills: [NewBill]
    
    @Query(filter: #Predicate<NewBill> { bill in
        bill.hasBeenPaid == false
    }, sort: \NewBill.dueByDate, order: .forward) var unpaidBills: [NewBill]

    @Query(filter: #Predicate<NewBill> { bill in
        bill.hasBeenPaid == true
    }, sort: \NewBill.dueByDate, order: .forward) var paidBills: [NewBill]
    
    @Published var currentList: [NewBill] = []
    
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
    
//    func moveBillsToNextMonth() {
//        billsPaidThisMonth()
//        for bill in userController.paidBills {
//            userController.updateBillToUnpaid(bill: bill)
//        }
//
//        for bill in userController.userBills {
//            let dateNum = Int(userController.df.string(from: bill.dueByDate))!
//            var dateComponents = DateComponents()
//            dateComponents.month = 1
//            if dateNum < 30 && fsCalendarView.currentPage.month != "March"{
//                let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
//                userController.updateBillData(bill: bill,
//                                              name: bill.name,
//                                              dollarAmount: bill.dollarAmount,
//                                              dueByDate: moveForwardOneMonth,
//                                              category: bill.category,
//                                              isOn30th: bill.isOn30th)
//                continue
//            }
//
//            switch fsCalendarView.currentPage.month {
//            case "January", "February", "April", "June", "August", "September", "November":
//                dateComponents.month = 1
//                let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
//                userController.updateBillData(bill: bill,
//                                              name: bill.name,
//                                              dollarAmount: bill.dollarAmount,
//                                              dueByDate: moveForwardOneMonth,
//                                              category: bill.category,
//                                              isOn30th: bill.isOn30th)
//                continue
//
//            case "May", "July", "October", "December":
//                if bill.isOn30th == true {
//                    dateComponents.month = 1
//                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
//                    userController.updateBillData(bill: bill,
//                                                  name: bill.name,
//                                                  dollarAmount: bill.dollarAmount,
//                                                  dueByDate: moveForwardOneMonth,
//                                                  category: bill.category,
//                                                  isOn30th: bill.isOn30th)
//                    continue
//                } else {
//                    dateComponents.month = 1
//                    dateComponents.day = 1
//                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
//                    userController.updateBillData(bill: bill,
//                                                  name: bill.name,
//                                                  dollarAmount: bill.dollarAmount,
//                                                  dueByDate: moveForwardOneMonth,
//                                                  category: bill.category,
//                                                  isOn30th: bill.isOn30th)
//                    continue
//                }
//
//            case "March":
//                if dateNum < 28 {
//                    dateComponents.month = 1
//                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
//                    userController.updateBillData(bill: bill,
//                                                  name: bill.name,
//                                                  dollarAmount: bill.dollarAmount,
//                                                  dueByDate: moveForwardOneMonth,
//                                                  category: bill.category,
//                                                  isOn30th: bill.isOn30th)
//                    continue
//                } else if dateNum == 28 {
//                    if bill.isOn30th == true {
//                        dateComponents.day = 2
//                    } else {
//                        dateComponents.day = 3
//                    }
//                    dateComponents.month = 1
//                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
//                    userController.updateBillData(bill: bill,
//                                                  name: bill.name,
//                                                  dollarAmount: bill.dollarAmount,
//                                                  dueByDate: moveForwardOneMonth,
//                                                  category: bill.category,
//                                                  isOn30th: bill.isOn30th)
//                    continue
//                } else if dateNum == 29 {
//                    if bill.isOn30th == true {
//                        dateComponents.day = 1
//                    } else {
//                        dateComponents.day = 2
//                    }
//                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponents, to: bill.dueByDate)!
//                    userController.updateBillData(bill: bill,
//                                                  name: bill.name,
//                                                  dollarAmount: bill.dollarAmount,
//                                                  dueByDate: moveForwardOneMonth,
//                                                  category: bill.category,
//                                                  isOn30th: bill.isOn30th)
//                    continue
//                }
//
//            default:
//                fatalError()
//            }
//        }
//    }
}

