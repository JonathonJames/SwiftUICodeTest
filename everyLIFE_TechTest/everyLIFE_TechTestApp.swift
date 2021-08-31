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
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                state: .loaded(
                    [
                        Task(
                            id: 1,
                            name: "Test Title",
                            description: "Test Description",
                            type: .general
                        )
                    ]
                )
            )
            .environment(\.repository, self.repository)
        }
    }
}

extension EnvironmentValues {
    var repository: TaskListRepositoryInterface? {
        get {
            self[TaskListRepositoryEnvironmentKey.self]
        }
        set {
            self[TaskListRepositoryEnvironmentKey.self] = newValue
        }
    }
}

private struct TaskListRepositoryEnvironmentKey: EnvironmentKey {
    static let defaultValue: TaskListRepositoryInterface? = nil
}
