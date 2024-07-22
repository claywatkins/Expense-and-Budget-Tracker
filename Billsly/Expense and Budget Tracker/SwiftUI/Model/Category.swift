//
//  Category.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 3/10/21.
//

import UIKit
import SwiftData

@Model
struct Category: Equatable, Hashable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
