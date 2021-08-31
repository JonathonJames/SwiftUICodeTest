//
//  Task.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 31/08/2021.
//

import Foundation


/// Describes a task which can be undertaken by the user.
struct Task: Decodable {
    
    /// Describes a category to which a `Task` can belong.
    enum Category: String, Decodable {
        case general
        case hydration
        case medication
        case nutrition
    }
    
    /// A unique identifier of the task.
    let id: Int64
    /// The human-readable name of the task.
    let name: String
    /// A human-readable description of the task.
    let description: String
    /// The `Category` to which this `Task` belongs.
    let type: Category
}
