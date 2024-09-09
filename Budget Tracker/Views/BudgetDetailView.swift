//
//  BudgetDetailView.swift
//  Budget Tracker
//
//  Created by Zain Malik on 28/08/2024.
//

import SwiftUI
import CoreData

struct BudgetDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var title: String = ""
    @State private var total: String = ""
    
    let budgetCategory: BudgetCatgory
    
    var isValidForm: Bool {
        guard let totalAsDouble = Double(total) else { return false }
        return !title.isEmpty && !total.isEmpty && totalAsDouble > 0
    }
    
    private func saveTransaction() {
        do {
            let transaction = Transaction(context: viewContext)
            transaction.title = title
            transaction.total = Double(total)!
            budgetCategory.addToTransactions(transaction)
            try viewContext.save()
            
            title = ""
            total = ""
            
            UIApplication.shared.endEditing()

        } catch {
            print(error)
        }
    }
    
    private func deleteTransaction(_ transaction: Transaction) {
        viewContext.delete(transaction)
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(budgetCategory.title ?? "")
                        .font(.custom("AvenirNext-Medium", size: geometry.size.width * 0.06))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    
                    HStack {
                        Text("Budget:")
                            .font(.custom("AvenirNext-Medium", size: geometry.size.width * 0.05))
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(budgetCategory.total as NSNumber, formatter: NumberFormatter.currency)
                            .font(.custom("AvenirNext-Medium", size: geometry.size.width * 0.06))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.black)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
                
                // Form Section
                VStack(spacing: 15) {
                    Text("Add Transaction")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    TextField("Enter Title", text: $title)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                    
                    TextField("Enter Total", text: $total)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                        .keyboardType(.decimalPad)
                        .foregroundColor(.black)
                    
                    Button("Save Transaction") {
                        saveTransaction()
                    }
                    .disabled(!isValidForm)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isValidForm ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                // Transaction Summary and List
                VStack {
                    BudgetSummaryView(budgetCategory: budgetCategory)
                        .padding()
                    TransactionListView(request: BudgetCatgory.transactionByCategoryRequest(budgetCategory), onDeleteTransaction: deleteTransaction)
                }
                .background(Color.white)
                .cornerRadius(15)
                .padding()
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



struct BudgetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock BudgetCatgory instance
        let mockCategory = BudgetCatgory(context: CoreDataManager.shared.viewContext)
        mockCategory.title = "Sample Budget"
        mockCategory.total = 500
        
        
        return BudgetDetailView(budgetCategory: mockCategory)
            .environment(\.managedObjectContext, CoreDataManager.shared.viewContext)
    }
}

