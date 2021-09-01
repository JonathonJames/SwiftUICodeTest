//
//  ViewState.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 01/09/2021.
//


/// Describes the state of a stateful view. Generic type provides the loaded data type.
enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case error(Error)
}
