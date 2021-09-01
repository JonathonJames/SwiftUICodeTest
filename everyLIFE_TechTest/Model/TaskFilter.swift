//
//  TaskFilter.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 01/09/2021.
//

struct TaskFilter: OptionSet {
    let rawValue: Int
    
    static let general = TaskFilter(rawValue: 1 << 0)
    static let medication = TaskFilter(rawValue: 1 << 2)
    static let hydration = TaskFilter(rawValue: 1 << 1)
    static let nutrition = TaskFilter(rawValue: 1 << 3)
    
    static let `default`: TaskFilter = [
        .general,
        .medication,
        .hydration,
        .nutrition
    ]
}
