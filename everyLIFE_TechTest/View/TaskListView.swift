//
//  ContentView.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 31/08/2021.
//

import SwiftUI
import Combine

/// A view representing a task list.
struct TaskListView: View {
    
    @ObservedObject var viewModel: TaskListViewModel
    
    var body: some View {
        ZStack {
            NavigationView {
                switch self.viewModel.state {
                case .idle:
                    Group {
                        List { }
                            .listStyle(PlainListStyle())
                            .onAppear {
                                self.viewModel.loadTasks(filter: self.viewModel.filter)
                            }
                            
                            .accessibilityIdentifier("TaskListView_Empty")
                        FilterView(viewModel: self.viewModel)
                            .accessibilityIdentifier("FilterView")
                    }
                    .navigationBarTitle("Tasks", displayMode: .inline)
                case .loading:
                    Group {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .accessibilityIdentifier("LoadingIndicator")
                        FilterView(viewModel: self.viewModel)
                            .accessibilityIdentifier("FilterView")
                    }
                    .navigationBarTitle("Tasks", displayMode: .inline)
                case .loaded(let tasks):
                    Group {
                        VStack {
                            List(tasks) { task in
                                TaskView(task: task)
                                    .accessibilityIdentifier("TaskView_\(task.type)_\(task.id)")
                            }
                            .listStyle(PlainListStyle())
                            .accessibilityIdentifier("TaskListView")
                            FilterView(viewModel: self.viewModel)
                                .accessibilityIdentifier("FilterView")
                        }
                    }
                    .navigationBarTitle("Tasks", displayMode: .inline)
                case .error(let error):
                    #warning("TODO: Add a pull to refresh, rather than the user needing to adjust the filter")
                    Group {
                        List {}
                        Text("Error loading tasks:\n\(error.localizedDescription)")
                            .accessibilityIdentifier("ErrorText")
                        FilterView(viewModel: self.viewModel)
                            .accessibilityIdentifier("FilterView")
                    }
                    .navigationBarTitle("Tasks", displayMode: .inline)
                }
            }
            
            if let transition: NetworkConnectionStatusTransition = self.viewModel.networkStatus {
                switch (transition.previous, transition.current) {
                case (.unknown, .disconnected),
                     (.connected, .disconnected):
                    ToastNotificationView(text: "Connection lost")
                        .animation(.easeOut(duration: 3))
                        .accessibilityIdentifier("ConnectionLostToast")
                case (.disconnected, .connected):
                    ToastNotificationView(color: .green, text: "Connection restored")
                        .onAppear {
                            // Refresh the tasks
                            self.viewModel.loadTasks(filter: self.viewModel.filter)
                        }
                        .animation(.easeOut(duration: 3))
                        .accessibilityIdentifier("ConnectionRestoredToast")
                default:
                    EmptyView()
                }
            }
        }
    }
}



struct TaskListView_Previews: PreviewProvider {
    
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
    
    private static let networkMonitor: NetworkConnectionMonitorInterface = {
        return NetworkConnectionMonitor()
    }()


    static var previews: some View {
        TaskListView(
            viewModel: .init(
                repository: self.repository,
                networkMonitor: self.networkMonitor
            )
        )
    }
}
