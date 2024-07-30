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
    var identifier: String
    var name: String
    var dollarAmount: Double
    var dueByDate: Date
    var hasBeenPaid: Bool
    var category: String
    var isOn30th: Bool
    var isAutopay: Bool
    var frequency: String

    init(identifier: String, name: String, dollarAmount: Double, dueByDate: Date, hasBeenPaid: Bool, category: String, isOn30th: Bool, isAutopay: Bool, frequency: String) {
        self.identifier = identifier
        self.name = name
        self.dollarAmount = dollarAmount
        self.dueByDate = dueByDate
        self.hasBeenPaid = hasBeenPaid
        self.category = category
        self.isOn30th = isOn30th
        self.isAutopay = isAutopay
        self.frequency = frequency
    }
    
    static func == (lhs: NewBill, rhs: NewBill) -> Bool {
        return lhs.identifier == rhs.identifier
    }
        
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
       
}
