//
//  CoreDataManager.swift
//  Budget Tracker
//
//  Created by Zain Malik on 27/08/2024.
//

import Foundation
import CoreData

class CoreDataManager{
    
    static let shared = CoreDataManager()
    private var persistentContainer: NSPersistentContainer
    
    private init() {
        self.persistentContainer = NSPersistentContainer(name: "BudgetModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error{
                fatalError("Unable to initialize Core Data stack \(error)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext{
        persistentContainer.viewContext
    }
    
}
