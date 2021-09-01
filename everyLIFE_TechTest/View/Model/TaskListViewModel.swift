//
//  TaskListViewModel.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 01/09/2021.
//

import Foundation
import Combine

final class TaskListViewModel: ObservableObject {
    
    @Published private(set) var state: ViewState<[Task]> = .idle
    @Published private(set) var filter: TaskFilter = .default
    @Published private(set) var networkStatus: NetworkConnectionStatusTransition? = nil
    
    private unowned let repository: TaskListRepositoryInterface
    private unowned let networkMonitor: NetworkConnectionMonitorInterface
    private var cancellables: [AnyCancellable] = []
    
    init(
        repository: TaskListRepositoryInterface,
        networkMonitor: NetworkConnectionMonitorInterface
    ) {
        self.repository = repository
        self.networkMonitor = networkMonitor
        
        self.networkMonitor.status
            .sink { [weak self] transition in
                guard let self = self else { return }
                self.networkStatus = transition
            }
            .store(in: &cancellables)
        
        self.$filter
            .sink { [weak self] filter in
                guard let self = self else { return }
                self.loadTasks(filter: filter)
            }
            .store(in: &self.cancellables)
    }
    
    func toggle(option: TaskFilter) {
        if self.filter.contains(option) {
            self.filter.remove(option)
        } else {
            self.filter.insert(option)
        }
    }
    
    func loadTasks(filter: TaskFilter) {
        self.state = .loading
        self.repository.retrieveTaskList(filter: filter)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let tasks):
                    self.state = .loaded(tasks)
                case .failure(let error):
                    self.state = .error(error)
                }
            }
            .store(in: &self.cancellables)
    }
}
