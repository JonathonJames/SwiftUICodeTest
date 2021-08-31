//
//  URLSessionNetworkService.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 31/08/2021.
//

import Foundation
import Combine

/// A concrete implementation of the `NetworkServiceInterface` protocol.
public final class URLSessionNetworkService: NetworkServiceInterface {
    
    /// The underlying session performing the tasks.
    private let session: URLSession
    
    /// Initializes a new `URLSessionNetworkService` instance with the specified `URLSession`.
    public init(session: URLSession) {
        self.session = session
    }
    
    /// Performs the specified `URLRequest`.
    /// - Parameter request: A `URLRequest` to be performed.
    /// - Returns: A publisher which will publish either the response or an error.
    public func performRequest(_ request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        self.session.dataTaskPublisher(for: request)
            .eraseToAnyPublisher()
    }
}
