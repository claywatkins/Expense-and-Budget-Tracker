//
//  CircularBillProgressView.swift
//  Expense and Budget Tracker
//
//  Created by Clayton Watkins on 5/22/24.
//

import SwiftUI
import FluidGradient
import SwiftData

struct CircularBillProgressView: View {
    @EnvironmentObject var billService: BillService
    @State private var toggleAnimation = false
    @State var progress: CGFloat = 0
    var colors: [Color]
    
    @Query(filter: #Predicate<NewBill> { bill in
        bill.hasBeenPaid == true
    }, sort: \NewBill.dueByDate, order: .forward) var paidBills: [NewBill]
    
    @Query(sort: \NewBill.dueByDate, order: .forward) var allBills: [NewBill]

    
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 15.0)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)

                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: colors),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 15.0, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
            }
            .frame(height: 140)
            .padding(.bottom, 8)
            .animation(.linear(duration: 2), value: progress)
            .modifier(ShadowViewModifier())
            .onAppear {
                progress = billService.getProgressFloat(paidBills: paidBills, allBills: allBills)
            }
            
            HStack(spacing: 5) {
                Text("You have paid")
                Text("\(progress, format: .percent)")
                Text("of this month's bills")
            }
            .modifier(ShadowViewModifier())
            .onAppear {
                withAnimation(.default) {
                    progress = billService.getProgressFloat(paidBills: paidBills, allBills: allBills)
                }
            }
        }
        .frame(height: 230)
    }
}

#Preview {
    @StateObject var userService = UserController()
    
    return CircularBillProgressView(colors: [.red, .blue, .yellow, .green, .purple])
            .environmentObject(userService)
}
