//
//  CoreDataBootcampApp.swift
//  CoreDataBootcamp
//
//  Created by AmirDiafi on 7/26/22.
//

import SwiftUI

@main
struct CoreDataBootcampApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
