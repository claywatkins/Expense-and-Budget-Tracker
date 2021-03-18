//
//  HomeViewController.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 3/11/21.
//

import UIKit
import FSCalendar
import Charts

class HomeViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountOfBillsPaid: UILabel!
    @IBOutlet weak var calendarHostView: UIView!
    @IBOutlet weak var fsCalendarView: FSCalendar!
    @IBOutlet weak var progressHostView: UIView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var paidBillButton: UIButton!
    @IBOutlet weak var manageBillsButton: UIButton!
    
    // MARK: - Properties
    let userController = UserController.shared
    let shapeLayer = CAShapeLayer()
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        userController.loadBillData()
        userController.loadCategoryData()
        displayDate()
        constructProgressCircle()
        print("Bills Count: \(userController.userBills.count)")
        print("Percentage Bills Paid: \(userController.calculatedBillProgressString)")
        print("Calculated Float: \(userController.calculatedBillProgressFloat)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fsCalendarView.reloadData()
        billsPaidThisMonth()
        setupCalendar()
        animateStrokeProgressCircle(float: userController.calculatedBillProgressFloat)
        print("Percentage Bills Paid: \(userController.calculatedBillProgressString)")
        print("Calculated Float: \(userController.calculatedBillProgressFloat)")
    }
    
    // MARK: - Methods
    private func displayDate() {
        userController.df.dateFormat = "EEEE, MMM d, yyyy"
        dateLabel.text = userController.df.string(from: Date())
    }
    
    private func setupCalendar() {
        fsCalendarView.placeholderType = .none
        fsCalendarView.isUserInteractionEnabled = false
        userController.df.dateFormat = "d"
        let todayStr = userController.df.string(from: fsCalendarView.today!)
        if userController.dueByDateStrings.contains(todayStr) {
            fsCalendarView.appearance.todayColor = .clear
        } else {
            fsCalendarView.appearance.todayColor = .systemTeal
        }
        fsCalendarView.register(FSCalendarCell.self, forCellReuseIdentifier: "calendarCell")
    }
    
    private func billsPaidThisMonth() {
        let billsPaid = userController.paidBills.count
        let totalBills = userController.userBills.count
        amountOfBillsPaid.text = "You have \(totalBills - billsPaid) bills left to pay this month."
    }
    
    private func constructProgressCircle() {
        progressBarView.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0,
                                       y: 0,
                                       width: 150,
                                       height: 150)
        percentageLabel.center = progressBarView.center
        let center = progressBarView.center
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: 100,
                                        startAngle: -CGFloat.pi/2,
                                        endAngle: 3*CGFloat.pi/2,
                                        clockwise: true)
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 12
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        progressBarView.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        progressBarView.layer.addSublayer(shapeLayer)
    }
    private func animateStrokeProgressCircle(float: CGFloat) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = float
        basicAnimation.duration = 2.5
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basic")
        percentageLabel.text = userController.calculatedBillProgressString
    }
    
    // MARK: - IBActions
    @IBAction func paidBillsButtonTapped(_ sender: Any) {
        if userController.userBills.isEmpty {
            let ac = UIAlertController(title: "No Bills Found", message: "You've got no bills to pay yet! Go on and add some first.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Sounds Good", style: .default, handler: nil))
            self.present(ac, animated: true)
        } else if userController.unpaidBills.isEmpty {
            let ac = UIAlertController(title: "All Bills Paid", message: "You've paid all your bills for the month!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Hooray!", style: .default, handler: nil))
            self.present(ac, animated: true)
        }
        let popoverContentController = self.storyboard?.instantiateViewController(withIdentifier: "BillPaidPopoverViewController") as? BillPaidPopoverViewController
        popoverContentController?.modalPresentationStyle = .popover
        popoverContentController?.delegate = self
        
        if let popoverPresentationController = popoverContentController?.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(origin: self.calendarHostView.center, size: .zero)
            popoverPresentationController.delegate = self
            if let popoverController = popoverContentController {
                present(popoverController, animated: true, completion: nil)
            }
        }
    }
    
}

// MARK: - Extension
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if self.traitCollection.userInterfaceStyle == .dark {
            var color = calendar.appearance.titleDefaultColor
            color = .white
            return color
        }
        return calendar.appearance.titleDefaultColor
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        userController.df.dateFormat = "d"
        let dateStr = userController.df.string(from: date)
        if userController.dueByDateStrings.contains(dateStr) {
            return ""
        }
        return userController.df.string(from: date)
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        userController.df.dateFormat = "dd"
        let dateStr = userController.df.string(from: date)
        if userController.dueByDateAndPaid.contains(dateStr) && userController.dueByDateAndUnpaid.contains(dateStr) {
            return UIImage(systemName: "dollarsign.circle.fill")
        } else if userController.dueByDateAndPaid.contains(dateStr) {
            return UIImage(systemName: "checkmark.seal.fill")
        } else if userController.dueByDateAndUnpaid.contains(dateStr) {
            return UIImage(systemName: "dollarsign.circle.fill")
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "calendarCell", for: date, at: position)
        userController.df.dateFormat = "dd"
        let dateStr = userController.df.string(from: date)
        if userController.dueByDateAndPaid.contains(dateStr) {
            cell.imageView.tintColor = .systemGreen
        } else if userController.dueByDateAndUnpaid.contains(dateStr) {
            cell.imageView.tintColor = .systemRed
        }
        cell.imageView.contentMode = .scaleAspectFit
        return cell
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        for bill in userController.userBills {
            userController.updateBillToUnpaid(bill: bill)
        }
        billsPaidThisMonth()
        
        for bill in userController.userBills {
            userController.df.dateFormat = "dd"
            let dateNum = Int(userController.df.string(from: bill.dueByDate))!
            if dateNum < 30 && calendar.currentPage.month != "March"{
                var dateComponent = DateComponents()
                dateComponent.month = 1
                let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponent, to: bill.dueByDate)!
                userController.updateBillData(bill: bill,
                                              name: bill.name,
                                              dollarAmount: bill.dollarAmount,
                                              dueByDate: moveForwardOneMonth,
                                              category: bill.category)
                calendar.reloadData()
            }
        }
        
        if calendar.currentPage.daysInMonth() == 30 {
            for bill in userController.userBills {
                userController.df.dateFormat = "dd"
                let dateStr = userController.df.string(from: bill.dueByDate)
                if dateStr == "31" {
                    var dateComponent = DateComponents()
                    dateComponent.month = 1
                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponent, to: bill.dueByDate)!
                    userController.updateBillData(bill: bill,
                                                  name: bill.name,
                                                  dollarAmount: bill.dollarAmount,
                                                  dueByDate: moveForwardOneMonth, category: bill.category)
                    calendar.reloadData()
                }
            }
        }
        if calendar.currentPage.daysInMonth() == 31{
            for bill in userController.userBills {
                userController.df.dateFormat = "dd"
                let dateStr = userController.df.string(from: bill.dueByDate)
                if dateStr == "30" {
                    var dateComponent = DateComponents()
                    dateComponent.month = 1
                    if calendar.currentPage.daysInMonth() != calendar.currentPage.daysInMonth(-1){
                        dateComponent.day = 1
                    }
                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponent, to: bill.dueByDate)!
                    userController.updateBillData(bill: bill,
                                                  name: bill.name,
                                                  dollarAmount: bill.dollarAmount,
                                                  dueByDate: moveForwardOneMonth, category: bill.category)
                    calendar.reloadData()
                }
            }
        }
        if calendar.currentPage.month == "August" {
            for bill in userController.userBills {
                userController.df.dateFormat = "dd"
                let dateStr = userController.df.string(from: bill.dueByDate)
                if dateStr == "31" {
                    var dateComponent = DateComponents()
                    dateComponent.month = 1
                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponent, to: bill.dueByDate)!
                    userController.updateBillData(bill: bill,
                                                  name: bill.name,
                                                  dollarAmount: bill.dollarAmount,
                                                  dueByDate: moveForwardOneMonth, category: bill.category)
                    calendar.reloadData()
                }
            }
        }
        if calendar.currentPage.month == "January" {
            for bill in userController.userBills {
                userController.df.dateFormat = "dd"
                let dateStr = userController.df.string(from: bill.dueByDate)
                if dateStr == "31" {
                    var dateComponent = DateComponents()
                    dateComponent.month = 1
                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponent, to: bill.dueByDate)!
                    userController.updateBillData(bill: bill,
                                                  name: bill.name,
                                                  dollarAmount: bill.dollarAmount,
                                                  dueByDate: moveForwardOneMonth, category: bill.category)
                    calendar.reloadData()
                }
            }
        }
        if calendar.currentPage.month == "February" {
            for bill in userController.userBills {
                userController.df.dateFormat = "dd"
                let dateStr = userController.df.string(from: bill.dueByDate)
                if dateStr == "31" {
                    var dateComponent = DateComponents()
                    dateComponent.month = 1
                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponent, to: bill.dueByDate)!
                    userController.updateBillData(bill: bill,
                                                  name: bill.name,
                                                  dollarAmount: bill.dollarAmount,
                                                  dueByDate: moveForwardOneMonth, category: bill.category)
                    calendar.reloadData()
                }
            }
        }
        if calendar.currentPage.month == "March" {
            for bill in userController.userBills {
                userController.df.dateFormat = "dd"
                let dateStr = userController.df.string(from: bill.dueByDate)
                let dateNum = Int(dateStr)!
                if dateNum < 28 {
                    var dateComponent = DateComponents()
                    dateComponent.month = 1
                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponent, to: bill.dueByDate)!
                    userController.updateBillData(bill: bill,
                                                  name: bill.name,
                                                  dollarAmount: bill.dollarAmount,
                                                  dueByDate: moveForwardOneMonth, category: bill.category)
                    calendar.reloadData()
                } else if dateNum == 28 {
                    var dateComponent = DateComponents()
                    dateComponent.month = 1
                    dateComponent.day = 3
                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponent, to: bill.dueByDate)!
                    userController.updateBillData(bill: bill,
                                                  name: bill.name,
                                                  dollarAmount: bill.dollarAmount,
                                                  dueByDate: moveForwardOneMonth, category: bill.category)
                    calendar.reloadData()
                } else if dateStr == "29" {
                    var dateComponent = DateComponents()
                    dateComponent.month = 1
                    dateComponent.day = 2
                    let moveForwardOneMonth = Calendar.current.date(byAdding: dateComponent, to: bill.dueByDate)!
                    userController.updateBillData(bill: bill,
                                                  name: bill.name,
                                                  dollarAmount: bill.dollarAmount,
                                                  dueByDate: moveForwardOneMonth, category: bill.category)
                    calendar.reloadData()
                }
                
            }
        }
        
    }
}

extension HomeViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension HomeViewController: BillHasBeenPaid {
    func updateCalendar() {
        fsCalendarView.reloadData()
        billsPaidThisMonth()
        animateStrokeProgressCircle(float: userController.calculatedBillProgressFloat)
    }
}
