//
//  TransactionCoreData.swift
//  Budget Tracker
//
//  Created by Zain Malik on 28/08/2024.
//

import Foundation
import CoreData


@objc(Transaction)
public class Transaction: NSManagedObject{
    
    public override func awakeFromInsert() {
        self.dateCreated = Date()
    }
    
}




