//
//  URLSessionNetworkServiceTests.swift
//  everyLIFE_TechTestTests
//
//  Created by Jonathon James on 31/08/2021.
//

import XCTest
import Combine
@testable import everyLIFE_TechTest

/// A class which encapsulates the unit tests for the `URLSessionNetworkService` type.
final class URLSessionNetworkServiceTests: XCTestCase {
    
    /// The network service being tested.
    private var vut: URLSessionNetworkService!
    /// Storage for the publishers to be cancelled.
    private var cancellables: [AnyCancellable] = []

    override func setUpWithError() throws {
        self.vut = URLSessionNetworkService(
            session: .init(configuration: .ephemeral)
        )
    }

    override func tearDownWithError() throws {
        self.vut = nil
    }

    /// Tests that a `URLSessionNetworkService` instance can correctly perform a network request.
    /// - Throws: An error if any of the test scenarios fail.
    ///
    /// Scenario 1:-
    ///   GIVEN that we have a `URLSessionNetworkService` instance
    ///   AND we perform a request using that instance on an endpoint we know exists
    ///   AND we have network connectivity
    ///   THEN a publisher should be created
    ///   AND that publisher should recieve a non-error response.
    func testNetworkServicePerformsRequest_success() throws {
        
        let expectation: XCTestExpectation = .init(description: "Expectation awaiting result of network request")
        
        let request: URLRequest = .init(url: URL(string: "https://adam-deleteme.s3.amazonaws.com/tasks.json")!)
        self.vut.performRequest(request)
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Unexpectedly recieved error: \(error)")
                }
                expectation.fulfill()
            } receiveValue: { data, response in
                guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse else {
                    XCTFail("Unexpected response type: \(response)")
                    return
                }
                guard httpResponse.statusCode == 200 else {
                    XCTFail("Request unexpectedly failed.")
                    return
                }
            }
            .store(in: &self.cancellables)
        
        self.wait(for: [expectation], timeout: 5.0)
    }
    
    /// Tests that a `URLSessionNetworkService` instance can correctly perform a network request.
    /// - Throws: An error if any of the test scenarios fail.
    ///
    /// Scenario 1:-
    ///   GIVEN that we have a `URLSessionNetworkService` instance
    ///   AND we perform a request using that instance on an endpoint we know does not exist
    ///   AND we have network connectivity
    ///   THEN a publisher should be created
    ///   AND that publisher should recieve an error response.
    func testNetworkServicePerformsRequest_failure() throws {
        
        let expectation: XCTestExpectation = .init(description: "Expectation awaiting result of network request")
        
        let request: URLRequest = .init(url: URL(string: "https://adam-deleteme.s3.amazonaws.com/tasks.jsn")!)
        self.vut.performRequest(request)
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { error in
                expectation.fulfill()
            } receiveValue: { data, response in
                guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse else {
                    XCTFail("Unexpected response type: \(response)")
                    return
                }
                guard httpResponse.statusCode != 200 else {
                    XCTFail("Request unexpectedly succeeded.")
                    return
                }
            }
            .store(in: &self.cancellables)
        
        self.wait(for: [expectation], timeout: 5.0)
    }
}
