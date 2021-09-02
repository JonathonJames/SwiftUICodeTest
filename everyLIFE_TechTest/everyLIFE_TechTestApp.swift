//
//  everyLIFE_TechTestApp.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 31/08/2021.
//

import SwiftUI

@main
struct everyLIFE_TechTestApp: App {
    
    private let repository: TaskListRepositoryInterface = {
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
    
    private let networkMonitor: NetworkConnectionMonitorInterface = {
        return NetworkConnectionMonitor()
    }()
    
    var body: some Scene {
        WindowGroup {
            TaskListView(
                viewModel: .init(
                    repository: self.repository,
                    networkMonitor: self.networkMonitor
                )
            )
            .accessibility(identifier: "TaskListView")
        }
    }
}
