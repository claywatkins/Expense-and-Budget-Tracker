//
//  BillTableViewCell.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 3/4/21.
//

import UIKit

class BillTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var billName: UILabel!
    @IBOutlet weak var paidUnpaidButton: UIButton!
    
    // MARK: - Properties
    var bill: Bill? {
        didSet{
            updateViews()
        }
    }
    
    // MARK: - Private Methods
    private func updateViews(){
        guard let bill = bill else { return }
        billName.text = bill.name
        if bill.hasBeenPaid {
            if let image = UIImage(named: "checked.png"){
                paidUnpaidButton.setImage(image, for: .normal)
            }
        } else {
            if let image = UIImage(named: "unchecked.png"){
                paidUnpaidButton.setImage(image, for: .normal)
            }
        }
    }
}