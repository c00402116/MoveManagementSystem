//
//  MMSApp.swift
//  Shared
//
//  Created by Daniel Metrejean on 2/3/22.
//

import SwiftUI

@main
struct MMSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
