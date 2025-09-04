//
//  MicrooledTestiOSApp.swift
//  MicrooledTestiOS
//
//  Created by Sébastien Rochelet on 04/09/2025.
//

import SwiftUI
import SwiftData

@main
struct MicrooledTestiOSApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TaskApp.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @State private var taskslistViewModel: TasksListViewModel
    
    init() {
        taskslistViewModel = TasksListViewModel(context: sharedModelContainer.mainContext)
    }
    
    var body: some Scene {
        WindowGroup {
            ListTasksView()
        }
        .modelContainer(sharedModelContainer)
        .environment(taskslistViewModel)
    }
}
