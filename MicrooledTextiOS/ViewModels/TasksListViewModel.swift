//
//  TasksListViewModel.swift
//  MicrooledTextiOS
//
//  Created by Sébastien Rochelet on 04/09/2025.
//

import Foundation
import Observation
import SwiftData

// The view model which permorm various actions on the tasks
@Observable class TasksListViewModel {
    //Two properties necessary for SwiftData to work
    private let context: ModelContext
    private let upcommingTasks = FetchDescriptor<TaskApp>()

    var tasks: [TaskApp] = []
    
    init(context: ModelContext) {
        self.context = context
        
        fetchTasks()
    }
    
    func fetchTasks() {
        if let fetchedTasks = try? context.fetch(upcommingTasks) {
            tasks = sortTasks(tasks: fetchedTasks)
        }
    }
    
    // Sorting the tasks, first by checking if they are both completed or incompleted then by title
    func sortTasks(tasks: [TaskApp]) -> [TaskApp] {
        return tasks.sorted(by: { task1, task2 in
            if (task1.isCompleted == task2.isCompleted) {
                return task1.title.compare(task2.title) == .orderedAscending ? true : false
            } else {
                return task1.isCompleted ? false : true
            }
        })
    }
    
    func addTask(_ title: String) {
        let newTask = TaskApp(title: title)
        
        context.insert(newTask)
        try? context.save()
        fetchTasks()
    }
    
    func deleteTask(task: TaskApp) {
        context.delete(task)
        try? context.save()
        fetchTasks()
    }
    
    func toggleTaskCompletion(task: TaskApp) {
        task.isCompleted.toggle()
        try? context.save()
        fetchTasks()
    }
}
