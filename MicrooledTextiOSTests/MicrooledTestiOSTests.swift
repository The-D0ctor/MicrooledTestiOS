//
//  MicrooledTestiOSTests.swift
//  MicrooledTestiOSTests
//
//  Created by Sébastien Rochelet on 04/09/2025.
//

import Testing
@testable import MicrooledTestiOS
import SwiftData

struct MicrooledTextiOSTests {
    private var container: ModelContainer!
    private var viewModel: TasksListViewModel!
    
    @MainActor mutating func createViewModelForTests() {
        container = {
            let schema = Schema([
                TaskApp.self,
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            
            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()
        
        viewModel = TasksListViewModel(context: container.mainContext)
    }

    // Testing the tasks list sorting
    
    @Test mutating func testTaskSortOnlyUncompleted() async throws {
        await createViewModelForTests()
        
        let unsortedTasks: [TaskApp] = [
            TaskApp(title: "Do the dishes"),
            TaskApp(title: "Take out the trash"),
            TaskApp(title: "Go Shopping"),
            TaskApp(title: "Clean the bathtub"),
        ]
        
        let sortedTasks: [TaskApp] = [
            TaskApp(title: "Clean the bathtub"),
            TaskApp(title: "Do the dishes"),
            TaskApp(title: "Go Shopping"),
            TaskApp(title: "Take out the trash"),
        ]
        
        #expect(viewModel.sortTasks(tasks: unsortedTasks) == sortedTasks)
    }
    
    @Test mutating func testTaskSortOnlyCompleted() async throws {
        await createViewModelForTests()
        
        let unsortedTasks: [TaskApp] = [
            TaskApp(title: "Do the dishes", isCompleted: true),
            TaskApp(title: "Take out the trash", isCompleted: true),
            TaskApp(title: "Go Shopping", isCompleted: true),
            TaskApp(title: "Clean the bathtub", isCompleted: true),
        ]
        
        let sortedTasks: [TaskApp] = [
            TaskApp(title: "Clean the bathtub", isCompleted: true),
            TaskApp(title: "Do the dishes", isCompleted: true),
            TaskApp(title: "Go Shopping", isCompleted: true),
            TaskApp(title: "Take out the trash", isCompleted: true),
        ]
        
        #expect(viewModel.sortTasks(tasks: unsortedTasks) == sortedTasks)
    }
    
    @Test mutating func testTaskSortMix() async throws {
        await createViewModelForTests()
        
        let unsortedTasks: [TaskApp] = [
            TaskApp(title: "Do the dishes", isCompleted: true),
            TaskApp(title: "Take out the trash", isCompleted: false),
            TaskApp(title: "Go Shopping", isCompleted: false),
            TaskApp(title: "Clean the bathtub", isCompleted: true),
        ]
        
        let sortedTasks: [TaskApp] = [
            TaskApp(title: "Go Shopping", isCompleted: false),
            TaskApp(title: "Take out the trash", isCompleted: false),
            TaskApp(title: "Clean the bathtub", isCompleted: true),
            TaskApp(title: "Do the dishes", isCompleted: true),
        ]
        
        #expect(viewModel.sortTasks(tasks: unsortedTasks) == sortedTasks)
    }
    
    
    // Testing adding a task to the datastore
    
    @Test mutating func testAddTaskToEmptyDatastore() async throws {
        await createViewModelForTests()
        
        let newTask: TaskApp = TaskApp(title: "Test Task")
        
        viewModel.addTask(newTask.title)
        
        #expect(viewModel.tasks == [newTask])
    }
    
    @Test mutating func testAddTaskToDatastore() async throws {
        await createViewModelForTests()
        
        viewModel.addTask("Test Task")
        viewModel.addTask("Existing Task")
        viewModel.addTask("Another Test Task")
        
        #expect(viewModel.tasks == [TaskApp(title: "Another Test Task"), TaskApp(title: "Existing Task"), TaskApp(title: "Test Task")])
    }
    
    
    // Testing deleting a task
    
    @Test mutating func testDeleteTask() async throws {
        await createViewModelForTests()
        
        viewModel.addTask("Test Task")
        viewModel.addTask("Existing Task")
        viewModel.addTask("Another Test Task")
        viewModel.deleteTask(task: viewModel.tasks[1])
        
        #expect(viewModel.tasks == [TaskApp(title: "Another Test Task"), TaskApp(title: "Test Task")])
    }
    
    @Test mutating func testDeleteSeveralTasks() async throws {
        await createViewModelForTests()
        
        viewModel.addTask("Test Task")
        viewModel.addTask("Existing Task")
        viewModel.addTask("Another Test Task")
        viewModel.deleteTask(task: viewModel.tasks[1])
        viewModel.deleteTask(task: viewModel.tasks[1])
        
        #expect(viewModel.tasks == [TaskApp(title: "Another Test Task")])
    }
    
    
    // Testing changing task status
    
    @Test mutating func testChangeTaskStatus() async throws {
        await createViewModelForTests()
        
        viewModel.addTask("Test Task")
        viewModel.addTask("Existing Task")
        viewModel.addTask("Another Test Task")
        viewModel.toggleTaskCompletion(task: viewModel.tasks[1])
        
        #expect(viewModel.tasks == [TaskApp(title: "Another Test Task"), TaskApp(title: "Test Task"), TaskApp(title: "Existing Task", isCompleted: true)])
        
        viewModel.toggleTaskCompletion(task: viewModel.tasks[2])
        
        #expect(viewModel.tasks == [TaskApp(title: "Another Test Task"), TaskApp(title: "Existing Task"), TaskApp(title: "Test Task")])
    }
    
    @Test mutating func testChangeSeveralTaskStatus() async throws {
        await createViewModelForTests()
        
        viewModel.addTask("Test Task")
        viewModel.addTask("Existing Task")
        viewModel.addTask("Another Test Task")
        viewModel.toggleTaskCompletion(task: viewModel.tasks[0])
        viewModel.toggleTaskCompletion(task: viewModel.tasks[1])
        
        #expect(viewModel.tasks == [TaskApp(title: "Existing Task"), TaskApp(title: "Another Test Task", isCompleted: true), TaskApp(title: "Test Task", isCompleted: true)])
        
        viewModel.toggleTaskCompletion(task: viewModel.tasks[2])
        
        #expect(viewModel.tasks == [TaskApp(title: "Existing Task"), TaskApp(title: "Test Task"), TaskApp(title: "Another Test Task", isCompleted: true)])
    }
}
