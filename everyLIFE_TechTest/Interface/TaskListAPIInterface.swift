//
//  TaskListAPIInterface.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 31/08/2021.
//

import Foundation
import Combine

/// Describes the interface for retrieving a list of tasks.
protocol TaskListAPIInterface: AnyObject {
    /// Retrieves the latest task list.
    /// - Returns: A publisher which will publish the results of the search.
    func retrieveTaskList() -> AnyPublisher<Result<[Task], Error>, Never>
}
