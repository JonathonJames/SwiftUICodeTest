//
//  NetworkConnectionMonitorInterface.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 01/09/2021.
//

import Combine

protocol NetworkConnectionMonitorInterface: AnyObject {
    var status: AnyPublisher<NetworkConnectionStatusTransition?, Never> { get }
}
