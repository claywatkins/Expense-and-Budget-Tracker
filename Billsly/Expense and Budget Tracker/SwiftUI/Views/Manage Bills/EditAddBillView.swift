//
//  EditAddBillView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/21/24.
//

import SwiftUI

struct EditAddBillView: View {
    @EnvironmentObject var userService: UserController
    @EnvironmentObject var billService: BillService
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State var isEdit: Bool
    @State var bill: NewBill?
    @State private var billName: String = ""
    @State private var billCost: Double = 0.0
    @State private var billCostString: String = "\(Locale().currencySymbol ?? "") 0.00"
    @State private var category: BillCategories = .subscription
    @State private var billDueDate: Date = Date.now
    @State private var removedCategory: String = ""
    @State private var isAutopay: Bool = false
    @State private var frequency: BillFrequency = .monthly
    
    
    var disabledButton: Bool {
        if billName.isEmpty || billCost.isZero {
            return true
        }
        return false
    }
    
    private let amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Section {
                        Text("Bill name")
                            .foregroundStyle(.primary)
                            .fontWeight(.semibold)
                            .font(.title)
                        
                        TextField("Bill name", text: $billName)
                            .foregroundStyle(.secondary)
                            .textFieldStyle(.roundedBorder)
                    }
                    Section {
                        HStack(alignment: .firstTextBaseline) {
                            Text("Bill cost is:")
                                .foregroundStyle(.primary)
                                .fontWeight(.semibold)
                                .font(.title)
                            
                            Text(billCostString)
                                .foregroundStyle(.primary)
                                .fontWeight(.semibold)
                                .font(.title2)
                        }
                        
                        TextField("Bill cost", value: $billCost, formatter: amountFormatter)
                            .keyboardType(.decimalPad)
                            .foregroundStyle(.secondary)
                            .textFieldStyle(.roundedBorder)
                            .onAppear {
                                if billCost.isZero {
                                    billCostString = "0.00"
                                } else {
                                    billCostString = userService.currencyNf.string(from: billCost as NSNumber) ?? ""
                                }
                            }
                            .onChange(of: billCost) {
                                if billCost.isZero {
                                    billCostString = "0.00"
                                } else {
                                    billCostString = userService.currencyNf.string(from: billCost as NSNumber) ?? ""
                                }
                            }
                    }
                    
                    Section {
                        Text("Category")
                            .foregroundStyle(.primary)
                            .fontWeight(.semibold)
                            .font(.title)
                        
                        Picker("", selection: $category) {
                            ForEach(BillCategories.allCases, id: \.self) { category in
                                Text(category.rawValue)
                                    .tag(category.rawValue)
                            }
                        }
                        .labelsHidden()
                    }
                    
                    Section {
                        HStack {
                            Text("Autopay?")
                                .foregroundStyle(.primary)
                                .fontWeight(.semibold)
                                .font(.title)
                            Spacer ()
                            Toggle("", isOn: $isAutopay)
                        }
                    }
                    
                    Section {
                        Text("How of often is this bill due?")
                            .foregroundStyle(.primary)
                            .fontWeight(.semibold)
                            .font(.title)
                        
                        Picker("frequency",
                               selection: $frequency) {
                            ForEach(BillFrequency.allCases, id: \.self) { frequency in
                                Text(frequency.rawValue)
                                    .tag(frequency.rawValue)
                            }
                        }
                    }
                    
                    Section {
                        Text("Due Date")
                            .foregroundStyle(.primary)
                            .fontWeight(.semibold)
                            .font(.title)
                        
                        DatePicker("", selection: $billDueDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                    
                    Button {
                        let isOn30thBool = billDueDate.dayInt == 30

                        if let bill = bill {
                            bill.name = billName
                            bill.dollarAmount = billCost
                            bill.dueByDate = billDueDate
                            bill.category = category.rawValue
                            bill.isOn30th = isOn30thBool
                            bill.isAutopay = isAutopay
                            bill.frequency = frequency.rawValue
                        } else {
                            let newBill = NewBill(identifier: UUID().uuidString,
                                                  name: billName,
                                                  dollarAmount: billCost,
                                                  dueByDate: billDueDate,
                                                  hasBeenPaid: false,
                                                  category: category.rawValue,
                                                  isOn30th: isOn30thBool,
                                                  isAutopay: isAutopay,
                                                  frequency: frequency.rawValue)
                            billService.saveBill(bill: newBill, context: context )
                        }
                        
                        dismiss()
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(disabledButton ? Color("foreground", bundle: Bundle.main) : Color("buttonColor", bundle: Bundle.main))
                            .overlay {
                                Text(isEdit ? "Update Bill" : "Save Bill")
                                    .foregroundStyle(Color(.label))
                            }
                            .frame(height: 50)
                            .modifier(ShadowViewModifier())
                    }
                    .disabled(disabledButton)
                }
                .padding()
                .navigationTitle(isEdit ? "Edit Bill" : "Add a Bill")
                .onAppear {
                    if isEdit {
                        if let bill = bill {
                            billName = bill.name
                            billCost = bill.dollarAmount
                            category = BillCategories(rawValue: bill.category) ?? .subscription
                            billDueDate = bill.dueByDate
                            isAutopay = bill.isAutopay
                            frequency = BillFrequency(rawValue: bill.frequency) ?? .monthly
                        }
                    }
                }
                .onDisappear {
                    if isEdit {
                        billService.billWasUpdatedTrigger.toggle()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.backward")
                                Text("Manage Bills")
                            }
                        }
                    }
                }
            }
        }
    }
}



//#Preview {
//    @StateObject var userService = UserController()
//
//    return EditAddBillView(isEdit: true,
//                           bill: Bill(identifier: UUID().uuidString,
//                                      name: "Bill Name",
//                                      dollarAmount: 10.50,
//                                      dueByDate: Date.now,
//                                      category: .init(name: "Test Category"),
//                                      isOn30th: false,
//                                      hasImage: nil))
//    .environmentObject(userService)
//}
