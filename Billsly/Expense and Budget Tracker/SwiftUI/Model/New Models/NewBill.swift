//
//  NewBill.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 7/30/24.
//

import SwiftUI
import SwiftData

@Model
class NewBill: Equatable, Hashable {
    var identifier: String = UUID().uuidString
    var name: String = ""
    var dollarAmount: Double = 0.0
    var dueByDate: Date = Date.now
    var hasBeenPaid: Bool = false
    var category: String = ""
    var isOn30th: Bool = false
    var isAutopay: Bool = false
    var frequency: String = ""
    var monthCount: Int = 0

    init(identifier: String, name: String, dollarAmount: Double, dueByDate: Date, hasBeenPaid: Bool, category: String, isOn30th: Bool, isAutopay: Bool, frequency: String, monthCount: Int) {
        self.identifier = identifier
        self.name = name
        self.dollarAmount = dollarAmount
        self.dueByDate = dueByDate
        self.hasBeenPaid = hasBeenPaid
        self.category = category
        self.isOn30th = isOn30th
        self.isAutopay = isAutopay
        self.frequency = frequency
        self.monthCount = monthCount
    }
    
    static func == (lhs: NewBill, rhs: NewBill) -> Bool {
        return lhs.identifier == rhs.identifier
    }
        
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
       
}
