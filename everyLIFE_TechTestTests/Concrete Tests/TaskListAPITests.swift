//
//  TaskListAPITests.swift
//  everyLIFE_TechTestTests
//
//  Created by Jonathon James on 31/08/2021.
//

import XCTest
import Combine
@testable import everyLIFE_TechTest

/// A class which encapsulates the unit tests for the `TaskListAPITests` type.
final class TaskListAPITests: XCTestCase {
    
    /// The network service being tested.
    private var vut: TaskListAPI!
    /// Storage for the publishers to be cancelled.
    private var cancellables: [AnyCancellable] = []
    /// A replica of the data from "https://adam-deleteme.s3.amazonaws.com/tasks.json" (as on 31/08/2021).
    private let json: Data = """
            [
              {
                "id": 1,
                "name": "Take the rubbish out",
                "description": "Empty the bin and take the rubbish and recycling to the communal rubbish bins that are on the lower ground floor of the building",
                "type": "general"
              },
              {
                "id": 2,
                "name": "Make a hot drink",
                "description": "Make David a cup of tea with full fat milk  and no sugar.  David likes to have his tea medium strength",
                "type": "hydration"
              },
              {
                "id": 3,
                "name": "5 ml Azopt 10mg/1ml",
                "description": "Instil one drop to both eyes at the morning. Put on by HM checked by VH. This is now only to be put in in the morning as the private carer will instil at lunch time",
                "type": "medication"
              },
              {
                "id": 4,
                "name": "Asprin",
                "description": "This is dispersible and should be dissolved in water and administered with or just after food.",
                "type": "medication"
              },
              {
                "id": 5,
                "name": "Make a snack",
                "description": "Soup, or biscuits or both. David also likes Advocate with salt on.  Request from David's son not to make any other food as David is not eating it and it is then left out overnight and attracting mice.",
                "type": "nutrition"
              },
              {
                "id": 6,
                "name": "Eyelid hygiene",
                "description": "The eyelids should be washed with a cotton bud dipped into a mixture of 1 part baby shampoo and 4 parts water. Linda is going to ensure that the cotton buds and baby shampoo are available. The care worker should wipe the outside of the eyelids with the cotton bud.",
                "type": "general"
              }
            ]
        """.data(using: .utf8)!

    override func setUpWithError() throws {
        self.vut = TaskListAPI(
            baseURL: "https://adam-deleteme.s3.amazonaws.com",
            service: URLSessionNetworkService(
                session: .init(configuration: .ephemeral)
            )
        )
    }

    override func tearDownWithError() throws {
        self.vut = nil
    }

    /// Tests that a `TaskListAPI` instance, using a `baseURL` of "https://adam-deleteme.s3.amazonaws.com" will retrieve data equal to
    /// that available from "https://adam-deleteme.s3.amazonaws.com/tasks.json" (as on 31/08/2021).
    /// - Throws: An error if any of the test scenarios fail.
    ///
    /// Scenario 1:-
    ///   GIVEN that we have a `TaskListAPI` instance
    ///   AND that instance uses "https://adam-deleteme.s3.amazonaws.com" as it's `baseURL`
    ///   AND we fetch the task list
    ///   THEN a publisher should be created
    ///   AND that publisher should recieve a non-error response, with the decoded data matching that
    ///       available from "https://adam-deleteme.s3.amazonaws.com/tasks.json" (as on 31/08/2021).
    func testTaskListAPIFetchesList_success() throws {
        
        let expectation: XCTestExpectation = .init(description: "Expectation awaiting result of fetching")
        
        self.vut.retrieveTaskList()
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { _ in
                expectation.fulfill()
            } receiveValue: { result in
                switch result {
                case .success(let tasks):
                    XCTAssertEqual(tasks, try! JSONDecoder().decode([Task].self, from: self.json), "Fetched data should match expected.")
                case .failure(let error):
                    XCTFail("Unexpectedly recieved error: \(error)")
                }
            }
            .store(in: &self.cancellables)

        self.wait(for: [expectation], timeout: 5.0)
    }
    
    /// Tests that a `TaskListAPI` instance, using an invalid `baseURL` will fail.
    /// - Throws: An error if any of the test scenarios fail.
    ///
    /// Scenario 1:-
    ///   GIVEN that we have a `TaskListAPI` instance
    ///   AND that instance uses "https://adam-deleteme.s2.amazonaws.com" as it's `baseURL`
    ///   AND we fetch the task list
    ///   THEN a publisher should be created
    ///   AND that publisher will return an error.
    func testTaskListAPIFetchesList_failure() throws {
        
        let vut: TaskListAPI = .init(
            baseURL: "https://adam-deleteme.s2.amazonaws.com",
            service: URLSessionNetworkService(
                session: .init(configuration: .ephemeral)
            )
        )
        
        let expectation: XCTestExpectation = .init(description: "Expectation awaiting result of fetching")
        
        vut.retrieveTaskList()
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { _ in
                expectation.fulfill()
            } receiveValue: { result in
                switch result {
                case .success:
                    XCTFail("The request has unexpectedly succeeded.")
                case .failure(let error):
                    print(error)
                }
            }
            .store(in: &self.cancellables)

        self.wait(for: [expectation], timeout: 5.0)
    }
}
