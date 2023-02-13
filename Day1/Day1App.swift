//
//  Day1App.swift
//  Day1
//
//  Created by 서종현 on 2023/02/02.
//

import SwiftUI

@main
struct Day1App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
