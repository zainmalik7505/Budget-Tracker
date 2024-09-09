//
//  ContentView.swift
//  Budget Tracker
//
//  Created by Zain Malik on 27/08/2024.
//

import SwiftUI
import CoreData

enum SheetAction: Identifiable {
    
    case add
    case edit(BudgetCatgory)
    
    var id: Int {
        switch self {
            case .add:
                return 1
            case .edit(_):
                return 2
        }
    }
    
}

struct ContentView: View {
    
    
    @Environment (\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var budgetCategoryResults: FetchedResults<BudgetCatgory>
    
    @State private var sheetAction: SheetAction?

    
    var netTotal: Double{
        budgetCategoryResults.reduce(0) { result, budgetCategory in
            return result + budgetCategory.total
        }
    }
    
    private func deleteBudgetCategory(budgetCategory: BudgetCatgory){
        viewContext.delete(budgetCategory)
        do{
            try viewContext.save()
        }catch{
            print("error")
        }
    }
    
    private func editBudgetCategory(budgetCategory: BudgetCatgory){
        sheetAction = .edit(budgetCategory)
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                HStack{
                    Text("Net Total - ")
                    
                    Text("\(netTotal as NSNumber, formatter: NumberFormatter.currency)")
                        .fontWeight(.bold)
                }
                
                BudgetListView(budgetCategoryResults: budgetCategoryResults, onDeleteBudget: deleteBudgetCategory, onEditBudgetCategory: editBudgetCategory)
            }
            
            .sheet(item: $sheetAction, content: { sheetAction in
                // display the sheet
                switch sheetAction {
                    case .add:
                        AddBudgetCategoryView()
                    case .edit(let budgetCategory):
                        AddBudgetCategoryView(budgetCategory: budgetCategory)
                }
            })
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Create Budget") { 
                        sheetAction = .add
                    }
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.white.edgesIgnoringSafeArea(.all)) // Changed background color to orange
        }
    }
}


#Preview {
    ContentView().environment(\.managedObjectContext, CoreDataManager.shared.viewContext)
}
