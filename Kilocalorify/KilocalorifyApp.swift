//
//  KilocalorifyApp.swift
//  Kilocalorify
//
//  Created by user222636 on 5/30/22.
//

import SwiftUI

@main
struct KilocalorifyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
