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
    @State private var categorySelection: String?
    @State private var billDueDate: Date = Date.now
    @State private var removedCategory: String = ""
    
    var disabledButton: Bool {
        if billName.isEmpty || billCost.isZero || categorySelection == nil {
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
                VStack(alignment: .leading) {
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
                        
                        Picker("", selection: $categorySelection) {
                            Text(isEdit ? bill?.category ?? "" : "Choose a catagory").tag(nil as String?)
                            ForEach(billService.defaultCategories.indices, id: \.self) { idx in
                                Text(billService.defaultCategories[idx])
                                    .tag(billService.defaultCategories[idx] as String?)
                            }
                        }
                        .labelsHidden()
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
                        guard let category = categorySelection else { return }
                        let isOn30thBool = billDueDate.dayInt == 30

                        if let bill = bill {
                            bill.name = billName
                            bill.dollarAmount = billCost
                            bill.dueByDate = billDueDate
                            bill.category = category
                            bill.isOn30th = isOn30thBool
                        } else {
                            let newBill = NewBill(identifier: UUID().uuidString,
                                                  name: billName,
                                                  dollarAmount: billCost,
                                                  dueByDate: billDueDate,
                                                  hasBeenPaid: false,
                                                  category: category,
                                                  isOn30th: isOn30thBool,
                                                  isAutopay: false,
                                                  frequency: "monthly")
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
                            categorySelection = bill.category
                            billDueDate = bill.dueByDate
                            if let billidx = billService.defaultCategories.firstIndex(of: bill.category) {
                                removedCategory = billService.defaultCategories.remove(at: billidx)
                            }
                        }
                    }
                }
                .onDisappear {
                    if isEdit {
                        billService.defaultCategories.append(removedCategory)
                        removedCategory = ""
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
