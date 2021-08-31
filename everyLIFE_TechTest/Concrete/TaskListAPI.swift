//
//  TaskListAPI.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 31/08/2021.
//

import Foundation
import Combine

/// A concrete implementation of the `TaskListAPIInterface` protocol.
final class TaskListAPI: TaskListAPIInterface {
    
    /// An exception that can occur when a URL is invalid.
    struct InvalidURLException: Error {
        let urlString: String
        var debugDescription: String {
            return "The string '\(self.urlString)' does not describe a valid URL."
        }
    }
    
    /// The base URL/host to use when constructing URLs.
    private let baseURL: String
    /// The URLSession to use when performing network requests.
    private let service: NetworkServiceInterface
    
    
    /// Creates a new `TaskListAPI` instance which will communicate with the specified `baseURL`, using the specified network `service`.
    /// - Parameters:
    ///   - baseURL: A `String` value containing the host/base URL.
    ///   - service: A `NetworkServiceInterface` conforming object which can perform the network requests.
    public init(baseURL: String, service: NetworkServiceInterface) {
        self.baseURL = baseURL
        self.service = service
    }
    
    /// Performs a search with the specified query.
    /// - Parameter query: The query to run during the search.
    /// - Returns: A publisher which will publish the results of the search.
    public func retrieveTaskList() -> AnyPublisher<Result<[Task], Error>, Never> {
        do {
            var request: URLRequest = .init(url: try self.constructURL(baseURL: self.baseURL, path: "tasks.json"))
            request.httpMethod = "GET"
            
            return self.service.performRequest(request)
                .tryMap({ element -> Data in
                    guard let httpResponse: HTTPURLResponse = element.response as? HTTPURLResponse,
                        httpResponse.statusCode >= 200 else {
                            throw URLError(.badServerResponse)
                        }
                    return element.data
                })
                .decode(type: [Task].self, decoder: JSONDecoder())
                .map({ .success($0) })
                .catch({ error in
                    Just(.failure(error))
                        .eraseToAnyPublisher()
                })
                .subscribe(on: DispatchQueue(label: "Search queue", qos: .background))
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } catch {
            return Just(.failure(error))
                .eraseToAnyPublisher()
        }
    }
    
    /// A utility method for constructing a URL from a given base URL, and a path.
    /// - Parameters:
    ///   - baseURL: The host/base URL from which the endpoint should be constructed.
    ///   - path: The path/endpoint to hit relative to the base URL.
    /// - Throws: `InvalidURLException` if a valid URL cannot be constructed.
    /// - Returns: A new `URL` value.
    private func constructURL(baseURL: String, path: String) throws -> URL {
        
        guard let components: URLComponents = .init(string:  (baseURL as NSString).appendingPathComponent(path) ) else {
            throw InvalidURLException(urlString: baseURL)
        }
        
        guard let url: URL = components.url else {
            guard let string: String = components.string else {
                throw InvalidURLException(urlString: baseURL)
            }
            throw InvalidURLException(urlString: string)
        }
        
        return url
    }
}

