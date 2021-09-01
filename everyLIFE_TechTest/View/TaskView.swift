//
//  TaskView.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 01/09/2021.
//

import SwiftUI

/// A view which displays a `Task`
struct TaskView: View {
    
    let task: Task
    
    var body: some View {
        HStack(spacing: 12) {
            switch task.type {
            case .general:
                Image("general_icon")
                    .frame(minWidth: 30, maxHeight: .infinity, alignment: .top)
            case .medication:
                Image("medication_icon")
                    .frame(maxHeight: .infinity, alignment: .top)
            case .hydration:
                Image("hydration_icon")
                    .frame(maxHeight: .infinity, alignment: .top)
            case .nutrition:
                Image("nutrition_icon")
                    .frame(maxHeight: .infinity, alignment: .top)
            }
            VStack {
                Text(self.task.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                Text(self.task.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
        }
    }
}
