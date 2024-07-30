//
//  EditAddBillView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/21/24.
//

import SwiftUI

struct EditAddBillView: View {
    @EnvironmentObject var userService: UserController
    @Environment(\.dismiss) var dismiss
    @State var isEdit: Bool
    @State var bill: NewBill?
    @State private var billName: String = ""
    @State private var billCost: String = ""
    @State private var categorySelection: Category?
    @State private var billDueDate: Date = Date.now
    
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
                        Text("Bill cost")
                            .foregroundStyle(.primary)
                            .fontWeight(.semibold)
                            .font(.title)
                        
                        TextField("Bill cost", text: $billCost)
                            .foregroundStyle(.secondary)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Section {
                        Text("Category")
                            .foregroundStyle(.primary)
                            .fontWeight(.semibold)
                            .font(.title)
                        
                        Picker("", selection: $categorySelection) {
                            Text(isEdit ? bill?.category ?? "" : "Choose a catagory").tag(nil as String?)
                            ForEach(userService.userCategories.indices, id: \.self) { idx in
                                Text(userService.userCategories[idx].name).tag(userService.userCategories[idx] as Category?)
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
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                    }
                    
                    
                    Button {
                        // Save
                        dismiss()
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(Color("buttonColor", bundle: Bundle.main))
                            .overlay {
                                Text("Save Bill")
                                    .foregroundStyle(Color(.label))
                            }
                            .frame(height: 50)
                            .modifier(ShadowViewModifier())
                    }
                }
                .padding()
                .navigationTitle(isEdit ? "Edit Bill" : "Add a Bill")
                .onAppear {
                    if isEdit {
                        if let bill = bill {
                            billName = bill.name
                            billCost = userService.currencyNf.string(from: bill.dollarAmount as NSNumber) ?? ""
                            categorySelection = Category(name: bill.category)
                            billDueDate = bill.dueByDate
                        }
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
