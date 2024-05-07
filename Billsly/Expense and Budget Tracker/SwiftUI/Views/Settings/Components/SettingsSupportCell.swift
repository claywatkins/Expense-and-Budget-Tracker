//
//  SettingsSupportCell.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/7/24.
//

import SwiftUI

struct SettingsSupportCell: View {
    var image: String
    var text: String
    var subtext: String
    var action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        } label: {
            HStack {
                Image(systemName: image)
                    .font(.system(size: 30))
                    .foregroundStyle(Color(uiColor: .label))
                
                VStack(alignment: .leading) {
                    Text(text)
                        .font(.headline)
                        .foregroundStyle(Color(uiColor: .label))
                    Text(subtext)
                        .font(.subheadline)
                        .foregroundStyle(Color(uiColor: .label))
                }
            }
        }
    }
}

#Preview {
    SettingsSupportCell(image: "hand.thumbsup",
                        text: "Leave a rating",
                        subtext: "Support me by leaving a review!",
                        action: {
        print("test")
    })
}
