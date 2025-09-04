//
//  Task.swift
//  MicrooledTextiOS
//
//  Created by Sébastien Rochelet on 04/09/2025.
//

import Foundation
import SwiftData

// The class representing the Task model
// The @Model macro is used to indicate to SwiftData to use it as a stored class
// The Equatable protocol is used for the unit tests
@Model
final class TaskApp: Identifiable, Equatable {
    static func == (lhs: TaskApp, rhs: TaskApp) -> Bool {
        lhs.title == rhs.title && lhs.isCompleted == rhs.isCompleted
    }
    
    var id: UUID = UUID()
    
    var title: String

    var isCompleted: Bool
    
    init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
    }
}
