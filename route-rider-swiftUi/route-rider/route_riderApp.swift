//
//  route_riderApp.swift
//  route-rider
//
//  Created by Thaer on 23.10.20.
//

import SwiftUI

@main
struct route_riderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
