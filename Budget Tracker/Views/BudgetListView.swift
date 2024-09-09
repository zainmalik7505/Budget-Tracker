//
//  BudgetListView.swift
//  Budget Tracker
//
//  Created by Zain Malik on 27/08/2024.
//


import SwiftUI

struct BudgetListView: View {
    let budgetCategoryResults: FetchedResults<BudgetCatgory>
    let onDeleteBudget: (BudgetCatgory) -> Void
    let onEditBudgetCategory: (BudgetCatgory) -> Void

    var body: some View {
        NavigationStack {
            List {
                if !budgetCategoryResults.isEmpty {
                    ForEach(budgetCategoryResults) { budgetCategory in
                        NavigationLink(value: budgetCategory) {
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(budgetCategory.title ?? "")
                                        .font(.custom("AvenirNext-Bold", size: 18))
                                        .foregroundColor(.white)
                                    Text(budgetCategory.total as NSNumber, formatter: NumberFormatter.currency)
                                        .font(.custom("AvenirNext-Regular", size: 16))
                                        .foregroundColor(.white)
                                }
                                .contentShape(Rectangle())
                                .onLongPressGesture {
                                    onEditBudgetCategory(budgetCategory)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 5) {
                                    Text(budgetCategory.overSpent ? "Over Spent" : "Remaining")
                                        .font(.custom("AvenirNext-Bold", size: 16))
                                        .foregroundColor(budgetCategory.overSpent ? .red : .green)
                                    Text(budgetCategory.remainingBudgetTotal as NSNumber, formatter: NumberFormatter.currency)
                                        .font(.custom("AvenirNext-Regular", size: 16))
                                        .foregroundColor(budgetCategory.overSpent ? .red : .green)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.black)
                                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 3)
                            )
                        }
                        .listRowBackground(Color.clear)
                        .padding(.vertical, 5)
                        .listRowInsets(EdgeInsets())
                    }
                    .onDelete { indexSet in
                        indexSet.map { budgetCategoryResults[$0] }.forEach(onDeleteBudget)
                    }
                } else {
                    Text("No Budget Exists")
                        .font(.custom("AvenirNext-Bold", size: 20))
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .listStyle(.plain)
            .navigationDestination(for: BudgetCatgory.self) { budgetCategory in
                BudgetDetailView(budgetCategory: budgetCategory)
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
        }
    }
}


