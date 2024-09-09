//
//  AddBudgetCategoryView.swift
//  Budget Tracker
//
//  Created by Zain Malik on 27/08/2024.
//

import SwiftUI

struct AddBudgetCategoryView: View {
    @State private var title: String = ""
    @State private var total: Double = 100
    @State private var manualAmount: String = ""
    @State private var useSlider: Bool = true
    @State private var messages: [String] = []

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    private var budgetCategory: BudgetCatgory?
    
    init(budgetCategory: BudgetCatgory? = nil) {
        self.budgetCategory = budgetCategory
    }

    var isValid: Bool {
        messages.removeAll()
        if title.isEmpty {
            messages.append("Title is required.")
        }
        if total <= 0 {
            messages.append("Total should be greater than 0.")
        }
        return messages.isEmpty
    }

    private func saveOrUpdate() {
        if let budgetCategory {
            let budget = BudgetCatgory.byId(budgetCategory.objectID)
            budget.title = title
            budget.total = total
        } else {
            let budgetCategory = BudgetCatgory(context: viewContext)
            budgetCategory.title = title
            budgetCategory.total = total
        }
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print(error)
        }
    }
    
    private func updateTotalFromManualInput() {
        if let value = Double(manualAmount) {
            total = value
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Create New Budget Category").font(.headline)) {
                    TextField("Enter Title", text: $title)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    Toggle("Use Slider", isOn: $useSlider)
                        .padding()
                    
                    if useSlider {
                        Slider(value: $total, in: 0...1000000, step: 1) {
                            Text("Total")
                        } minimumValueLabel: {
                            Text("0")
                        } maximumValueLabel: {
                            Text("1M")
                        }
                        .accentColor(.teal)
                        .padding()
                    } else {
                        TextField("Enter Amount", text: $manualAmount)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .onChange(of: manualAmount) { _ in
                                updateTotalFromManualInput()
                            }
                    }
                    
                    if !messages.isEmpty {
                        ForEach(messages, id: \.self) { message in
                            Text(message)
                                .foregroundColor(.red)
                                .font(.subheadline)
                        }
                    }
                    
                    Text(total as NSNumber, formatter: NumberFormatter.currency)
                        .font(.title3)
                        .foregroundColor(.blue)
                        .padding(.top)
                }
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .onAppear {
                if let budgetCategory {
                    self.title = budgetCategory.title ?? ""
                    self.total = budgetCategory.total
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if isValid {
                            saveOrUpdate()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AddBudgetCategoryView()
}
