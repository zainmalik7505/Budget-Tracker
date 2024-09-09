//
//  NumberFormatter + Extensions.swift
//  Budget Tracker
//
//  Created by Zain Malik on 27/08/2024.
//

import Foundation

extension NumberFormatter{
    
    static var currency: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
}
