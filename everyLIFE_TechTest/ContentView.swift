//
//  ContentView.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 31/08/2021.
//

import SwiftUI
import Combine

enum ViewState<Data> {
    case idle
    case loading
    case loaded(Data)
    case error(Error)
}

struct ContentView: View {
    
    @ObservedObject var viewModel: TaskListViewModel
    
    var body: some View {
        NavigationView {
            switch self.viewModel.state {
            case .idle:
                Group {
                    List { }
                        .listStyle(PlainListStyle())
                        .onAppear {
                            self.viewModel.loadTasks(filter: self.viewModel.filter)
                        }
                    FilterView(viewModel: self.viewModel)
                }
                .navigationBarTitle("Tasks", displayMode: .inline)
            case .loading:
                Group {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    FilterView(viewModel: self.viewModel)
                }
                .navigationBarTitle("Tasks", displayMode: .inline)
            case .loaded(let tasks):
                Group {
                    VStack {
                        List(tasks) { task in
                            TaskView(task: task)
                        }
                        .listStyle(PlainListStyle())
                        FilterView(viewModel: self.viewModel)
                    }
                }
                .navigationBarTitle("Tasks", displayMode: .inline)
            case .error(let error):
                #warning("TODO: Present the error message.")
                Group {
                    List { }
                        .listStyle(PlainListStyle())
                    FilterView(viewModel: self.viewModel)
                }
                .navigationBarTitle("Tasks", displayMode: .inline)
            }
        }
    }
}


struct FilterView: View {
    
    @ObservedObject var viewModel: TaskListViewModel

    var body: some View {
        HStack(alignment: .center, spacing: 24) {
            FilterIcon(imageName: "general_icon", isActive: self.viewModel.filter.contains(.general))
                .onTapGesture {
                    self.viewModel.toggle(option: .general)
                }
            FilterIcon(imageName: "medication_icon", isActive: self.viewModel.filter.contains(.medication))
                .onTapGesture {
                    self.viewModel.toggle(option: .medication)
                }
            FilterIcon(imageName: "hydration_icon", isActive: self.viewModel.filter.contains(.hydration))
                .onTapGesture {
                    self.viewModel.toggle(option: .hydration)
                }
            FilterIcon(imageName: "nutrition_icon", isActive: self.viewModel.filter.contains(.nutrition))
                .onTapGesture {
                    self.viewModel.toggle(option: .nutrition)
                }
        }
        .frame(maxHeight: 44, alignment: .center)
    }
}

struct FilterIcon: View {
    
    let imageName: String
    let isActive: Bool
    
    var body: some View {
        if self.isActive {
            Image(self.imageName)
        } else {
            Image(self.imageName)
                .renderingMode(.template)
                .foregroundColor(.gray)
        }
    }
}

    
    final class TaskListViewModel: ObservableObject {
        
        @Published fileprivate(set) var state: ViewState<[Task]> = .idle
        @Published fileprivate(set) var filter: TaskFilter = .default
        
        private let repository: TaskListRepositoryInterface
        private var cancellables: [AnyCancellable] = []
        
        init(repository: TaskListRepositoryInterface) {
            self.repository = repository
            
            self.$filter
                .sink { filter in
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
                .sink { result in
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

struct ContentView_Previews: PreviewProvider {
    
    private static let repository: TaskListRepositoryInterface = {
        return TaskListRepository(
            api: TaskListAPI(
                baseURL: "https://adam-deleteme.s3.amazonaws.com",
                service: URLSessionNetworkService(
                    session: .init(
                        configuration: .ephemeral
                    )
                )
            ),
            persistence: GRDBDatabase()
        )
    }()

    static var previews: some View {
        ContentView(viewModel: .init(repository: self.repository))
    }
}


struct TaskView: View {
    
    var task: Task
    
    var body: some View {
        HStack(spacing: 12) {
            switch task.type {
            case .general:
                Image("general_icon")
                    .frame(maxHeight: .infinity, alignment: .top)
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
        }
    }
}
