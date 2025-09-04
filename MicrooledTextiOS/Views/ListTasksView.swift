//
//  ContentView.swift
//  MicrooledTextiOS
//
//  Created by Sébastien Rochelet on 04/09/2025.
//

import SwiftUI
import SwiftData

struct ListTasksView: View {
    @Environment(TasksListViewModel.self) private var tasksListViewModel
    
    @State var isAddAlertPresented: Bool = false
    @State var newTaskTitle: String = ""
    
    var body: some View {
        VStack {
            if (tasksListViewModel.tasks.isEmpty) {
                Text("No Tasks")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(UIColor.systemGray6))
            }
            else {
                List {
                    ForEach(tasksListViewModel.tasks) { task in
                        TaskItemView(task: task)
                            //Swipe Action from right to left for deleting a task
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    tasksListViewModel.deleteTask(task: task)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            //Swipe Action from left to right for marking a task as completed/uncompleted
                            .swipeActions(edge: .leading) {
                                Button {
                                    tasksListViewModel.toggleTaskCompletion(task: task)
                                } label: {
                                    Label("Mark as \(task.isCompleted ? "not done" : "done")", systemImage: task.isCompleted ? "circle" : "checkmark.circle")
                                }
                                .tint(task.isCompleted ? .gray : .green)
                            }
                    }
                }
                
            }
            Button {
                newTaskTitle = ""
                isAddAlertPresented = true
            } label: {
                Label("Add Task", systemImage: "plus")
            }
            .padding(.top, 10)
        }
        .alert("Add Task", isPresented: $isAddAlertPresented) {
            TextField("Task title", text: $newTaskTitle)
            Button("Ok") {
                if (!newTaskTitle.isEmpty) {
                    tasksListViewModel.addTask(newTaskTitle)
                }
            }
        }
    }
}

#Preview {
    let sharedModelContainer: ModelContainer = {
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
    
    let context = sharedModelContainer.mainContext
    
    ListTasksView().modelContainer(sharedModelContainer)
        .environment(TasksListViewModel(context: context))
}
