//
//  ExpenseController.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 3/3/21.
//

import SwiftUI

enum BillSelection: String, CaseIterable {
    case unpaid = "Unpaid Bills"
    case all = "All Bills"
    case paid = "Paid Bills"
}

class UserController: ObservableObject {
    // MARK: - Properties
    static let shared = UserController()
    let df = DateFormatter()
    let nf = NumberFormatter()
    @Published var userBills: [Bill] = []
    @Published var userCategories: [Category] = []
    let defaults = UserDefaults.standard
    var isLoggedIn: Bool?
    @Published var username: String?
    @Published var currentList: [Bill] = []
    @Published var billType: BillSelection = .unpaid
    var persistentBillsFileURL: URL? {
        let fm = FileManager.default
        guard let documents = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documents.appendingPathComponent("userBills.plist")
    }
    var persistentCategoriesFileURL: URL? {
        let fm = FileManager.default
        guard let documents = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documents.appendingPathComponent("userCategories.plist")
    }
    var paidBills: [Bill] {
        let bills = userBills
        let filteredPaidBills = bills.filter{ (bills) -> Bool in bills.hasBeenPaid == true }
        let sortedBills = filteredPaidBills.sorted { $0.dueByDate < $1.dueByDate }
        return sortedBills
    }
    var unpaidBills: [Bill] {
        let bills = userBills
        let filteredUnpaidBills = bills.filter { (bills) -> Bool in bills.hasBeenPaid == false }
        let sortedBills = filteredUnpaidBills.sorted { $0.dueByDate < $1.dueByDate }
        return sortedBills
    }
    var dueByDateStrings: [String] {
        var dateArray: [String] = []
        for bill in userBills {
            let dateStr = self.df.string(from: bill.dueByDate)
            dateArray.append(dateStr)
        }
        return dateArray
    }
    var dueByDateAndPaid: [String] {
        var dateArray: [String] = []
        for bill in userBills {
            if bill.hasBeenPaid {
                let dateStr = self.df.string(from: bill.dueByDate)
                dateArray.append(dateStr)
            }
        }
        return dateArray
    }
    var dueByDateAndUnpaid: [String] {
        var dateArray: [String] = []
        for bill in userBills {
            if bill.hasBeenPaid == false {
                let dateStr = self.df.string(from: bill.dueByDate)
                dateArray.append(dateStr)
            }
        }
        return dateArray
    }
    var calculatedBillProgressString: String {
        let paidBillsCount = Float(paidBills.count)
        let totalBillsCount = Float(userBills.count)
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = "%"
        let billsPaidPercentage = paidBillsCount/totalBillsCount * 100
        return pFormatter.string(from: NSNumber(value: billsPaidPercentage))!
    }
    var calculatedBillProgressFloat: CGFloat {
        let paidBillsCount = CGFloat(paidBills.count)
        let totalBillsCount = CGFloat(userBills.count)
        return paidBillsCount/totalBillsCount
    }
    var alphabetizedCategories: [Category] {
        let categories = userCategories
        let alphabetizeCategories = categories.sorted { $0.name.lowercased() < $1.name.lowercased() }
        return alphabetizeCategories
    }
    var amountSpentOnBills: Double {
        var count = 0.0
        for bill in paidBills {
            count += bill.dollarAmount
        }
        return count

    }
    var mediumDf: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }
    var currencyNf: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        return nf
    }
    
    var billsInYear: [Int] {
        var yearInts: [Int] = []
        for bill in userBills {
            yearInts.append(bill.dueByDate.yearInt)
        }
        return Array(Set(yearInts).sorted())
    }
    
    // MARK: - Methods
    func getProgressFloat() -> CGFloat {
        if paidBills.count == 0 || userBills.count == 0 {
            return 0
        }
        let paidBillsCount = CGFloat(paidBills.count)
        let totalBillsCount = CGFloat(userBills.count)
        return paidBillsCount/totalBillsCount.rounded()
    }
    
    func setupCounts(selection: BillSelection) -> [Int: Int] {
        switch selection {
        case .all:
            let mappedItems = userBills.map{($0.dueByDate.dayInt, 1)}
            return Dictionary(mappedItems, uniquingKeysWith: +)
        case .paid:
            let mappedItems = paidBills.map{($0.dueByDate.dayInt, 1)}
            return Dictionary(mappedItems, uniquingKeysWith: +)
        case .unpaid:
            let mappedItems = unpaidBills.map{($0.dueByDate.dayInt, 1)}
            return Dictionary(mappedItems, uniquingKeysWith: +)
        }
    }
    
    func getCorrectList(selection: BillSelection) -> [Bill] {
        switch selection {
        case .all:
            return userBills.sorted(by: { $0.dueByDate < $1.dueByDate })
        case .unpaid:
            return unpaidBills
        case .paid:
            return paidBills
        }
    }
    
    func getBillsForDay(dayInt: Int) -> [Bill?] {
        let mappedBills = userBills.map{
            var bill: Bill?
            if $0.dueByDate.dayInt == dayInt {
                bill = $0
            }
            return bill
        }
        return mappedBills
    }
    
    
    func setUsername(_ username: String) {
        UserDefaults.standard.setValue(username, forKey: "username")
    }
    
    func loadUsername() {
        guard let username = UserDefaults.standard.value(forKey: "username") as? String else { return }
        self.username = username
    }
    
    func loadDefaultCategories() async {
        if userCategories.isEmpty {
            let defaultCategories: [Category] = [
                Category(name: "Subscription"),
                Category(name: "Utility"),
                Category(name: "Rent"),
                Category(name: "Mortgage"),
                Category(name: "Loan"),
                Category(name: "Credit Card"),
                Category(name: "Insurance"),
                Category(name: "Car Loan"),
                Category(name: "Other"),
            ]
            for i in defaultCategories {
                DispatchQueue.main.async {
                    self.userCategories.append(i)                    
                }
            }
            saveCategoriesToPersistentStore()
        }
    }
    
    func getRandomInt() -> Int {
        return Int.random(in: 0...7)
    }
    
    func generateTestBills() async {        
        for i in 0..<200 {
            let bill = Bill(identifier: UUID().uuidString,
                            name: "Test \(i)",
                            dollarAmount: 12.22,
                            dueByDate: Date.now,
                            category: userCategories[getRandomInt()],
                            isOn30th: false,
                            hasImage: nil)
            DispatchQueue.main.async {
                self.userBills.append(bill)
            }
        }
    }
    
    func sendDataToWidget(bill: Bill) {
        if #available(iOS 14, *) {
            let billToSend = WidgetData(billToWidget: bill)
            billToSend.storeBillInUserDefaults()
        }
    }
    
    func getValidBillAndSend() {
        if let billForWidget = unpaidBills.first {
            sendDataToWidget(bill: billForWidget)
        } else {
            let nilBill = Bill(identifier: UUID().uuidString,
                               name: "All Bills Paid!",
                               dollarAmount: 0.00,
                               dueByDate: Date(),
                               category: Category(name: ""),
                               isOn30th: false,
                               hasImage: false)
            sendDataToWidget(bill: nilBill)
        }
    }
    
    func getColors() async -> [Color]{
        var colors: [Color] = [.cyan,
                               .green,
                               .orange,
                               .purple,
                               .pink,
                               .mint,
                               .teal,
                               .yellow,
                               .blue,
                               .red]
//        for category in userCategories {
//            switch category.name {
//            case "Subscription":
//                colors.append(.cyan)
//            case "Utility":
//                colors.append(.green)
//            case "Rent":
//                colors.append(.orange)
//            case "Mortgage":
//                colors.append(.purple)
//            case "Loan":
//                colors.append(.mint)
//            case "Credit Card":
//                colors.append(.pink)
//            case "Insurance":
//                colors.append(.teal)
//            case "Car Loan":
//                colors.append(.yellow)
//            case "Other":
//                colors.append(.blue)
//            default:
//                colors.append(.red)
//            }
//        }
        return colors
    }
    
    // MARK: - CRUD
    func createBill(identifier: String, name: String, dollarAmount: Double, dueByDate: Date, category: Category, isOn30th: Bool) {
        let newBill = Bill(identifier: identifier,
                           name: name,
                           dollarAmount: dollarAmount,
                           dueByDate: dueByDate,
                           category: category,
                           isOn30th: isOn30th,
                           hasImage: true)
        userBills.append(newBill)
        print("Bill Added Successfully")
        saveBillsToPersistentStore()
    }
    func createCategory(name: String) {
        let newCategory = Category(name: name)
        userCategories.append(newCategory)
        print("Category saved")
        saveCategoriesToPersistentStore()
    }
    func updateBillHasBeenPaid(bill: Bill) {
        if let billIndex = userBills.firstIndex(of: bill) {
            userBills[billIndex].hasBeenPaid.toggle()
        }
        
        saveBillsToPersistentStore()
    }
    func updateBillToUnpaid(bill: Bill) {
        if let billIndex = userBills.firstIndex(of: bill) {
            userBills[billIndex].hasBeenPaid = false
        }
        saveBillsToPersistentStore()
    }
    func updateBillData(bill: Bill, name: String, dollarAmount: Double, dueByDate: Date, category: Category, isOn30th: Bool) {
        if let billIndex = userBills.firstIndex(of: bill) {
            userBills[billIndex].name = name
            userBills[billIndex].dollarAmount = dollarAmount
            userBills[billIndex].dueByDate = dueByDate
            userBills[billIndex].category = category
            userBills[billIndex].isOn30th = isOn30th
        }
        saveBillsToPersistentStore()
    }
    func deleteBillData(bill: Bill){
        guard let billIndex = userBills.firstIndex(of: bill) else { return }
        userBills.remove(at: billIndex)
        saveBillsToPersistentStore()
    }
    func deleteCategoryData(category: Category) {
        guard let categoryIndex = userCategories.firstIndex(of: category) else { return }
        userCategories.remove(at: categoryIndex)
        saveCategoriesToPersistentStore()
    }
    
    // MARK: - Persistence
    func saveBillsToPersistentStore() {
        //        guard let url = persistentBillsFileURL else { return }
        do{
            let data = try PropertyListEncoder().encode(self.userBills)
            if let billsURL = persistentBillsFileURL {
                try data.write(to: billsURL)
                getValidBillAndSend()
            }
            print("Bill Saved Succesfully")
        } catch {
            print("Error encoding bill data")
            print(error.localizedDescription)
        }
    }
    func loadBillData() {
        let fm = FileManager.default
        guard let url = persistentBillsFileURL, fm.fileExists(atPath: url.path) else { return }
        do{
            let data = try Data(contentsOf: url)
            self.userBills = try PropertyListDecoder().decode([Bill].self, from: data)
        } catch {
            print("Error loading bill data")
            print(error.localizedDescription)
        }
    }
    func saveCategoriesToPersistentStore() {
        guard let url = persistentCategoriesFileURL else { return }
        do {
            let data = try PropertyListEncoder().encode(self.userCategories)
            try data.write(to: url)
        } catch {
            print("Error saving Category data")
            print(error.localizedDescription)
        }
    }
    
    func loadCategoryData() {
        let fm = FileManager.default
        guard let url = persistentCategoriesFileURL, fm.fileExists(atPath: url.path) else { return }
        do {
            let data = try Data(contentsOf: url)
            self.userCategories = try PropertyListDecoder().decode([Category].self, from: data)
            print("Category Loaded")
        } catch {
            print("Error loading Category data")
            print(error.localizedDescription)
        }
    }
}
