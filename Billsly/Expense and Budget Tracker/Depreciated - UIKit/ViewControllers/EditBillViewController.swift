//
//  EditBillViewController.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 3/11/21.
//

import UIKit
import FSCalendar

//class EditBillViewController: UIViewController {
//    // MARK: - IBOutlets
//    @IBOutlet weak var billNameLabel: UILabel!
//    @IBOutlet weak var billNameTextField: UITextField!
//    @IBOutlet weak var dollarAmountLabel: UILabel!
//    @IBOutlet weak var dollarAmountTextField: UITextField!
//    @IBOutlet weak var categoryLabel: UILabel!
//    @IBOutlet weak var addCategoryButton: UIButton!
//    @IBOutlet weak var categoryTextField: UITextField!
//    @IBOutlet weak var dateDueLabel: UILabel!
//    @IBOutlet weak var selectedDateLabel: UILabel!
//    @IBOutlet weak var fsCalendarView: FSCalendar!
//    @IBOutlet weak var updateBillButton: UIButton!
//    @IBOutlet weak var contentView: UIView!
//    
//    // MARK: - Properties
//    var userController = UserController.shared
//    var bill: Bill?
//    var amt = 0
//    var delegate: CategoryCellTapped?
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        updateViews()
//        configureCalendar()
//        addDoneButtonOnKeyboard()
//        self.hideKeyboardWhenTappedAround()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        updateUIAppearence()
//    }
//    
//    // MARK: - Methods
//    private func updateViews() {
//        guard let bill = bill else { return }
//        fsCalendarView.select(bill.dueByDate)
//        fsCalendarView.today = nil
//        navigationItem.title = bill.name
//        billNameTextField.text = bill.name
//        userController.nf.numberStyle = .currency
//        dollarAmountTextField.text = userController.nf.string(from: NSNumber(value: bill.dollarAmount))
//        categoryTextField.text = bill.category.name
//        userController.df.dateFormat = "EEEE, MMM d, yyyy"
//        selectedDateLabel.text = userController.df.string(from: bill.dueByDate)
//    }
//    
//    private func updateUIAppearence() {
//        let defaults = UserDefaults.standard
//        let selection = defaults.integer(forKey: "appearanceSelection")
//        switch selection {
//        case 0:
//            customUIAppearance()
//        case 1:
//            overrideUserInterfaceStyle = .dark
//            darkLightMode()
//            darkModeNav()
//        case 2:
//            overrideUserInterfaceStyle = .light
//            darkLightMode()
//            lightModeNav()
//        case 3:
//            overrideUserInterfaceStyle = .unspecified
//            darkLightMode()
//            if traitCollection.userInterfaceStyle == .light {
//                lightModeNav()
//            } else {
//                darkModeNav()
//            }
//        default:
//            print("Error")
//            break
//        }
//    }
//    
//    private func customUIAppearance() {
//        fsCalendarView.appearance.weekdayTextColor = ColorsHelper.powderBlue
//        fsCalendarView.appearance.headerTitleColor = ColorsHelper.powderBlue
//        fsCalendarView.calendarHeaderView.tintColor = ColorsHelper.powderBlue
//        fsCalendarView.backgroundColor = ColorsHelper.slateGray
//        
//        contentView.backgroundColor = ColorsHelper.blackCoral
//        view.backgroundColor = ColorsHelper.blackCoral
//        billNameLabel.textColor = ColorsHelper.cultured
//        billNameTextField.textColor = ColorsHelper.cultured
//        billNameTextField.backgroundColor = ColorsHelper.slateGray
//        billNameTextField.layer.borderWidth = 1
//        billNameTextField.layer.borderColor = ColorsHelper.apricot.cgColor
//        billNameTextField.layer.cornerRadius = 8
//        billNameTextField.attributedPlaceholder = NSAttributedString(string: "Bill Name",
//                                                                     attributes: [NSAttributedString.Key.foregroundColor : ColorsHelper.cultured])
//        dollarAmountLabel.textColor = ColorsHelper.cultured
//        dollarAmountTextField.textColor = ColorsHelper.cultured
//        dollarAmountTextField.backgroundColor = ColorsHelper.slateGray
//        dollarAmountTextField.layer.borderWidth = 1
//        dollarAmountTextField.layer.borderColor = ColorsHelper.apricot.cgColor
//        dollarAmountTextField.layer.cornerRadius = 8
//        dollarAmountTextField.attributedPlaceholder = NSAttributedString(string: "Dollar Amount",
//                                                                         attributes: [NSAttributedString.Key.foregroundColor : ColorsHelper.cultured])
//        categoryLabel.textColor = ColorsHelper.cultured
//        categoryTextField.textColor = ColorsHelper.cultured
//        categoryTextField.backgroundColor = ColorsHelper.slateGray
//        categoryTextField.layer.borderWidth = 1
//        categoryTextField.layer.borderColor = ColorsHelper.apricot.cgColor
//        categoryTextField.layer.cornerRadius = 8
//        categoryTextField.attributedPlaceholder = NSAttributedString(string: "Tap + to add a category or create your own",
//                                                                     attributes: [NSAttributedString.Key.foregroundColor : ColorsHelper.cultured])
//        addCategoryButton.tintColor = ColorsHelper.cultured
//        
//        dateDueLabel.textColor = ColorsHelper.cultured
//        selectedDateLabel.textColor = ColorsHelper.cultured
//        
//        updateBillButton.configureButton(ColorsHelper.slateGray)
//    
//        fsCalendarView.appearance.weekdayTextColor = ColorsHelper.powderBlue
//        fsCalendarView.appearance.headerTitleColor = ColorsHelper.powderBlue
//        fsCalendarView.calendarHeaderView.tintColor = ColorsHelper.powderBlue
//        fsCalendarView.backgroundColor = ColorsHelper.slateGray
//        fsCalendarView.appearance.selectionColor = ColorsHelper.celadonGreen
//    }
//    
//    private func darkLightMode() {
//        contentView.backgroundColor = UIColor(named: "background")
//        view.backgroundColor = UIColor(named: "background")
//        billNameLabel.textColor = UIColor(named: "text")
//        billNameTextField.textColor = UIColor(named: "text")
//        billNameTextField.backgroundColor = UIColor(named: "foreground")
//
//        billNameTextField.layer.borderWidth = 1
//        billNameTextField.layer.borderColor = ColorsHelper.apricot.cgColor
//        billNameTextField.layer.cornerRadius = 8
//        billNameTextField.attributedPlaceholder = NSAttributedString(string: "Bill Name",
//                                                                     attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "text")!])
//        dollarAmountLabel.textColor = UIColor(named: "text")
//        dollarAmountTextField.textColor = UIColor(named: "text")
//        dollarAmountTextField.backgroundColor = UIColor(named: "foreground")
//        dollarAmountTextField.layer.borderWidth = 1
//        dollarAmountTextField.layer.borderColor = ColorsHelper.apricot.cgColor
//        dollarAmountTextField.layer.cornerRadius = 8
//        dollarAmountTextField.attributedPlaceholder = NSAttributedString(string: "Dollar Amount",
//                                                                         attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "text")!])
//        categoryLabel.textColor = UIColor(named: "text")
//        categoryTextField.textColor = UIColor(named: "text")
//        categoryTextField.backgroundColor = UIColor(named: "foreground")
//        categoryTextField.layer.borderWidth = 1
//        categoryTextField.layer.borderColor = ColorsHelper.apricot.cgColor
//        categoryTextField.layer.cornerRadius = 8
//        categoryTextField.attributedPlaceholder = NSAttributedString(string: "Tap + to add a category or create your own",
//                                                                     attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "text")!])
//        addCategoryButton.tintColor = UIColor(named: "text")
//        
//        dateDueLabel.textColor = UIColor(named: "text")
//        selectedDateLabel.textColor = UIColor(named: "text")
//        
//        updateBillButton.configureButton(UIColor(named: "foreground"))
//        updateBillButton.setTitleColor(UIColor(named: "text"), for: .normal)
//        
//        fsCalendarView.appearance.weekdayTextColor = UIColor(named: "text")
//        fsCalendarView.appearance.headerTitleColor = UIColor(named: "text")
//        fsCalendarView.calendarHeaderView.tintColor = UIColor(named: "text")
//        fsCalendarView.backgroundColor = UIColor(named: "foreground")
//        fsCalendarView.appearance.selectionColor = ColorsHelper.celadonGreen
//    }
//    
//    private func darkModeNav() {
//        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorsHelper.cultured]
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorsHelper.cultured]
//    }
//        
//    private func lightModeNav() {
//        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
//    }
//    
//    private func configureCalendar() {
//        fsCalendarView.today = nil
//        fsCalendarView.placeholderType = .none
//        fsCalendarView.appearance.selectionColor = ColorsHelper.celadonGreen
//        fsCalendarView.layer.cornerRadius = 12
//    }
//    
//    private func updateAmount() -> String? {
//        userController.nf.numberStyle = .currency
//        userController.nf.locale = Locale.current
//        let amount = Double(amt/100) + Double (amt%100)/100
//        return userController.nf.string(from: NSNumber(value: amount))
//    }
//    
//    private func convertCurrencyToDouble(input: String) -> Double? {
//        userController.nf.numberStyle = .currency
//        userController.nf.locale = Locale.current
//        return userController.nf.number(from: input)?.doubleValue
//    }
//    
//    private func addDoneButtonOnKeyboard() {
//        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
//        doneToolbar.barStyle = UIBarStyle.default
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(AddBillViewController.doneButtonAction))
//        
//        var items = [UIBarButtonItem]()
//        items.append(flexSpace)
//        items.append(done)
//        
//        doneToolbar.items = items
//        doneToolbar.sizeToFit()
//        
//        self.dollarAmountTextField.inputAccessoryView = doneToolbar
//    }
//    
//    @objc func doneButtonAction() {
//        self.dollarAmountTextField.resignFirstResponder()
//    }
//    
//    private func presentAlertController(missing: String) -> UIAlertController {
//        let ac = UIAlertController(title: "Missing \(missing)", message: "Please add a \(missing.lowercased()) to continue", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
//        return ac
//    }
//    
//    // MARK: IBActions
//    @IBAction func updateBillButtonTapped(_ sender: Any) {
//        guard let bill = bill else { return }
//        guard let name = billNameTextField.text, !name.isEmpty else {
//            let ac = presentAlertController(missing: "Name")
//            return present(ac, animated: true)
//        }
//        guard let amount = dollarAmountTextField.text, !amount.isEmpty else {
//            let ac = presentAlertController(missing: "Dollar Amount")
//            return present(ac, animated: true)
//        }
//        guard let finalAmount = convertCurrencyToDouble(input: amount) else { return }
//        guard let category = categoryTextField.text, !category.isEmpty else {
//            let ac = presentAlertController(missing: "Category")
//            return present(ac, animated: true)
//        }
//        guard let date = selectedDateLabel.text else { return }
//        guard let saveableDate = userController.df.date(from: date) else {
//            let ac = presentAlertController(missing: "Date")
//            return present(ac, animated: true)
//        }
//        
//        var billDate: Int {
//            userController.df.dateFormat = "d"
//            return Int(userController.df.string(from: saveableDate))!
//        }
//        
//        var isOn30th: Bool {
//            if billDate == 30 {
//                return true
//            }
//            return false
//        }
//        
//        userController.updateBillData(bill: bill,
//                                      name: name,
//                                      dollarAmount: finalAmount,
//                                      dueByDate: saveableDate,
//                                      category: Category(name: category),
//                                      isOn30th: isOn30th)
//        
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    @IBAction func addCategoryButtonTapped(_ sender: Any) {
//        let popoverContentController = self.storyboard?.instantiateViewController(withIdentifier: "CategoryPopoverViewController") as? CategoryPopoverViewController
//        popoverContentController?.modalPresentationStyle = .popover
//        popoverContentController?.delegate = self
//        
//        if let popoverPresentationController = popoverContentController?.popoverPresentationController {
//            popoverPresentationController.permittedArrowDirections = .any
//            popoverPresentationController.sourceView = addCategoryButton
//            popoverPresentationController.sourceRect = CGRect(origin: addCategoryButton.center, size: .zero)
//            popoverPresentationController.delegate = self
//            if let popoverController = popoverContentController {
//                present(popoverController, animated: true, completion: nil)
//            }
//        }
//    }
//}
//
////MARK: - Extension
//extension EditBillViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        userController.df.dateFormat = "EEEE, MMM d, yyyy"
//        selectedDateLabel.text = userController.df.string(from: date)
//    }
//    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
//        let defaults = UserDefaults.standard
//        let selection = defaults.integer(forKey: "appearanceSelection")
//        var colorSelection: UIColor?
//        switch selection{
//        case 0:
//            colorSelection = ColorsHelper.cultured
//        case 1...3:
//            colorSelection = UIColor(named: "text")
//        default:
//            break
//        }
//        return colorSelection ?? ColorsHelper.cultured
//    }
//    
//    func maximumDate(for calendar: FSCalendar) -> Date {
//        return fsCalendarView.currentPage.endOfMonth
//    }
//    
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        return fsCalendarView.currentPage.startOfMonth
//    }
//}
//
//extension EditBillViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == dollarAmountTextField{
//            if let digit = Int(string) {
//                amt = amt * 10 + digit
//                dollarAmountTextField.text = updateAmount()
//            }
//            if string == "" {
//                amt = amt/10
//                dollarAmountTextField.text = updateAmount()
//            }
//            return false
//        }
//        return true
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
//}
//
//extension EditBillViewController: UIPopoverPresentationControllerDelegate {
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return .none
//    }
//}
//
//extension EditBillViewController: CategoryCellTapped {
//    func categoryCellTapped(name: String) {
//        categoryTextField.text = name
//    }
//}
