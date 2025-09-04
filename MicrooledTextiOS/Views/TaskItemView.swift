//
//  TaskItemView.swift
//  MicrooledTextiOS
//
//  Created by Sébastien Rochelet on 04/09/2025.
//

import SwiftUI

// View representing a single task
struct TaskItemView: View {
    var task: TaskApp
    
    var body: some View {
        HStack {
            Text(task.title)
                .strikethrough(task.isCompleted)
                .foregroundStyle(task.isCompleted ? Color.gray : .primary)
                .font(.title2)
            if (task.isCompleted) {
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.green)
                    .frame(width: 30)
            }
        }
        .frame(height: 80)
    }
}

#Preview {
    TaskItemView(task: TaskApp(title: "Test", isCompleted: true))
}
