//
//  Budget_TrackerApp.swift
//  Budget Tracker
//
//  Created by Zain Malik on 27/08/2024.
//

import SwiftUI

@main
struct Budget_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, CoreDataManager.shared.viewContext)
        }
    }
}
