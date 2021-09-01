//
//  TaskListRepository.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 31/08/2021.
//

import Foundation
import Combine

final class TaskListRepository: TaskListRepositoryInterface {
    
    /// Underlying API to retrieve latest remote version of the task list.
    private var api: TaskListAPIInterface
    /// Underlying persistence layer for local data.
    private var persistence: PersistenceLayerInterface
    /// Storage for the publishers to be cancelled.
    private var cancellables: [AnyCancellable] = []
    
    /// Creates a new `TaskListRepository` instance.
    /// - Parameter api: The API to use when fetching remote data.
    init(
        api: TaskListAPIInterface,
        persistence: PersistenceLayerInterface
    ) {
        self.api = api
        self.persistence = persistence
    }
    
    /// Retrieves the latest task list.
    /// - Parameter filter: A filter for which tasks should be included.
    /// - Returns: A publisher which will publish the results of the search.
    func retrieveTaskList(filter: TaskFilter) -> AnyPublisher<Result<[Task], Error>, Never> {
    
        return self.api.retrieveTaskList()
            .receive(on: DispatchQueue.global(qos: .background))
            .map { result -> Result<[Task], Error> in
                switch result {
                case .success(let tasks):
                    do {
                        try self.persistence.insertOrUpdate(tasks)
                    } catch {
                        #warning("TODO: Log error with a proper logging mechanism.")
                        print("An error occured when trying to update local storage: \(error).")
                    }
                case .failure(let error):
                    #warning("TODO: Log error with a proper logging mechanism.")
                    print("An error occured when trying to update local storage: \(error).")
                    
                    // Try and retrieve data from local persistence layer instead.
                    return .init(catching: { try self.persistence.fetch() })
                }
                return result
            }
            .map({ result -> Result<[Task], Error> in
                // The API doesn't provide a filter in this case. So we need to apply the filter manually, after the fact.
                guard case .success(let tasks) = result else {
                    return result
                }
                return .success(
                    tasks.filter { task in
                        switch task.type {
                        case .general:
                            return filter.contains(.general)
                        case .medication:
                            return filter.contains(.medication)
                        case .hydration:
                            return filter.contains(.hydration)
                        case .nutrition:
                            return filter.contains(.nutrition)
                        }
                    }
                )
            })
            .eraseToAnyPublisher()
    }
}
