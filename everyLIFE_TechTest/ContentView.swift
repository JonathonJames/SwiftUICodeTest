//
//  ContentView.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 31/08/2021.
//

import SwiftUI


enum ViewState<Data> {
    case idle
    case loading
    case loaded(Data)
    case error(Error)
}

struct ContentView: View {
    
    @State var state: ViewState<[Task]>
    
    init(state: ViewState<[Task]>) {
        self._state = .init(wrappedValue: state)
    }
    
    var body: some View {
        switch self.state {
        case .idle:
            List { }
        case .loading:
            List { }
        case .loaded(let tasks):
            List(tasks) { task in
                TaskView(task: task)
            }
        case .error(let error):
            List { }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            state: .loaded(
                [
                    Task(
                        id: 1,
                        name: "Test Title",
                        description: "Test Description",
                        type: .general
                    ),
                    Task(
                        id: 2,
                        name: "Hydration ahoy!",
                        description: "Drink!",
                        type: .hydration
                    )
                ]
            )
        )
    }
}


struct TaskView: View {
    
    var task: Task
    
    var body: some View {
        HStack {
            Image(systemName: "person")
                .frame(maxHeight: .infinity, alignment: .top)
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
