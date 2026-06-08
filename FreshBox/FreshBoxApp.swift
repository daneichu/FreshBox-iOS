//
//  FreshBoxApp.swift
//  FreshBox
//
//  Created by kimgahyun on 5/19/26.
//

import SwiftUI
import CoreData

@main
struct FreshBoxApp: App {
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
 
