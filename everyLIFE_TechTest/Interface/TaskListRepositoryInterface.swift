//
//  TaskListRepositoryInterface.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 31/08/2021.
//

import Foundation
import Combine

/// Describes the interface for a task list repository, from which a task list can be retrieved.
protocol TaskListRepositoryInterface: AnyObject {
    /// Retrieves the latest task list.
    /// - Parameter filter: A filter for which tasks should be included.
    /// - Returns: A publisher which will publish the results of the search.
    func retrieveTaskList(filter: TaskFilter) -> AnyPublisher<Result<[Task], Error>, Never>
}
