//
//  BudgetCatgory+CoreDataClass.swift
//  Budget Tracker
//
//  Created by Zain Malik on 27/08/2024.
//

import Foundation
import CoreData

@objc(BudgetCatgory)
public class BudgetCatgory: NSManagedObject{
    
    public override func awakeFromInsert() {
        self.dateCreated = Date()
    }
    
    var overSpent: Bool{
        remainingBudgetTotal < 0
    }
    
    var transactionTotal:Double{
        trasactionsArray.reduce(0) {result , transaction in
            result + transaction.total
        }
    }
    
    var remainingBudgetTotal: Double{
        self.total - transactionTotal
    }
    
    private var trasactionsArray: [Transaction]{
        guard let transactions = transactions else { return [] }
        let allTransactions = (transactions.allObjects as? [Transaction]) ?? []
        return allTransactions.sorted{ t1, t2 in
            t1.dateCreated! > t2.dateCreated!
            
        }
    }
    
    static func byId(_ id : NSManagedObjectID) -> BudgetCatgory{
        let vc = CoreDataManager.shared.viewContext
        guard let budgetCategory = vc.object(with: id) as? BudgetCatgory else{
           fatalError("Id not found")
        }
        return budgetCategory
    }
    
    static func transactionByCategoryRequest(_ budgetCategory: BudgetCatgory) ->NSFetchRequest<Transaction>{
        let request = Transaction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        request.predicate = NSPredicate(format: "category = %@", budgetCategory)
        return request
    }
}
