//
//  Bill.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 3/3/21.
//

import Foundation

class Bill: Codable, Equatable, Hashable {
    var identifier: String
    var name: String
    var dollarAmount: Double
    var dueByDate: Date
    var hasBeenPaid: Bool
    var category: Category
    var isOn30th: Bool
    var hasImage: Bool?
    
    init(identifier: String,
         name: String,
         dollarAmount: Double,
         dueByDate: Date,
         category: Category,
         isOn30th: Bool,
         hasImage: Bool?) {
        self.identifier = identifier
        self.name = name
        self.dollarAmount = dollarAmount
        self.dueByDate = dueByDate
        self.hasBeenPaid = false
        self.category = category
        self.isOn30th = isOn30th
        self.hasImage = hasImage
    }
        
    static func == (lhs: Bill, rhs: Bill) -> Bool {
        return lhs.identifier == rhs.identifier
    }
        
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
        
    enum CodingKeys: String, CodingKey {
        case identifier
        case name
        case dollarAmount
        case dueByDate
        case hasBeenPaid
        case category
        case isOn30th
        case hasImage
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.name = try container.decode(String.self, forKey: .name)
        self.dollarAmount = try container.decode(Double.self, forKey: .dollarAmount)
        self.dueByDate = try container.decode(Date.self, forKey: .dueByDate)
        self.hasBeenPaid = try container.decode(Bool.self, forKey: .hasBeenPaid)
        self.category = try container.decode(Category.self, forKey: .category)
        self.isOn30th = try container.decode(Bool.self, forKey: .isOn30th)
        self.hasImage = try container.decodeIfPresent(Bool.self, forKey: .hasImage)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(name, forKey: .name)
        try container.encode(dollarAmount, forKey: .dollarAmount)
        try container.encode(dueByDate, forKey: .dueByDate)
        try container.encode(hasBeenPaid, forKey: .hasBeenPaid)
        try container.encode(category, forKey: .category)
        try container.encode(isOn30th, forKey: .isOn30th)
        try container.encode(hasImage, forKey: .hasImage)
    }
}
