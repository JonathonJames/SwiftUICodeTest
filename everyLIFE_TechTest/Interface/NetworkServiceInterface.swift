//
//  NetworkServiceInterface.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 31/08/2021.
//

import Foundation
import Combine

/// Describes a network service which can perform a `URLRequest`.
public protocol NetworkServiceInterface: AnyObject {
    
    /// Performs the specified `URLRequest`.
    /// - Parameter request: A `URLRequest` to be performed.
    /// - Returns: A publisher which will publish either the response or an error.
    func performRequest(_ request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

