//
//  Color+Extension.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/21/24.
//

import Foundation
import SwiftUI

extension Color: RawRepresentable {

    public init?(rawValue: String) {
        guard let data = Data(base64Encoded: rawValue) else {
            self = .blue
            return
        }
        
        do {
            let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor ?? .blue
            self = Color(color)
        } catch {
            self = .blue
        }
    }

    public var rawValue: String {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()
        } catch {
            return ""
        }
    }

}
