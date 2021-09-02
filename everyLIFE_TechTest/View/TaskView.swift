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
                    .accessibility(identifier: "TaskView_Icon_General")
            case .medication:
                Image("medication_icon")
                    .frame(maxHeight: .infinity, alignment: .top)
                    .accessibility(identifier: "TaskView_Icon_Medication")
            case .hydration:
                Image("hydration_icon")
                    .frame(maxHeight: .infinity, alignment: .top)
                    .accessibility(identifier: "TaskView_Icon_Hydration")
            case .nutrition:
                Image("nutrition_icon")
                    .frame(maxHeight: .infinity, alignment: .top)
                    .accessibility(identifier: "TaskView_Icon_Nutrition")
            }
            VStack {
                Text(self.task.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                    .accessibility(identifier: "TaskView_Title_Text")
                Text(self.task.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .accessibility(identifier: "TaskView_Description_Text")
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
        }
    }
}
