//
//  BudgetSummaryView.swift
//  Budget Tracker
//
//  Created by Zain Malik on 28/08/2024.
//

import SwiftUI

struct BudgetSummaryView: View {
    
    @ObservedObject var budgetCategory: BudgetCatgory
    
    var body: some View {
        HStack {
            Text(budgetCategory.overSpent ? "Over Spent" : "Remaining")
                .font(.subheadline)
                .foregroundColor(budgetCategory.overSpent ? .red : .green)
                .padding()
            Text(budgetCategory.remainingBudgetTotal as NSNumber, formatter: NumberFormatter.currency)
                .font(.subheadline)
                .foregroundColor(budgetCategory.overSpent ? .red : .green)
                .padding()

        }.background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        )
        .padding(.horizontal)
    }
}
//#Preview {
//    BudgetSummaryView(budgetCategory: <#BudgetCatgory#>)
//}
