//
//  FilterView.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 01/09/2021.
//

import SwiftUI

/// A view representing a filter for within a `TaskListView`
struct FilterView: View {
    
    @ObservedObject var viewModel: TaskListViewModel

    var body: some View {
        HStack(alignment: .center, spacing: 24) {
            FilterIcon(imageName: "general_icon", isActive: self.viewModel.filter.contains(.general))
                .onTapGesture {
                    self.viewModel.toggle(option: .general)
                }
                .accessibilityIdentifier("FilterIcon_General")
            FilterIcon(imageName: "medication_icon", isActive: self.viewModel.filter.contains(.medication))
                .onTapGesture {
                    self.viewModel.toggle(option: .medication)
                }
                .accessibilityIdentifier("FilterIcon_Medication")
            FilterIcon(imageName: "hydration_icon", isActive: self.viewModel.filter.contains(.hydration))
                .onTapGesture {
                    self.viewModel.toggle(option: .hydration)
                }
                .accessibilityIdentifier("FilterIcon_Hydration")
            FilterIcon(imageName: "nutrition_icon", isActive: self.viewModel.filter.contains(.nutrition))
                .onTapGesture {
                    self.viewModel.toggle(option: .nutrition)
                }
                .accessibilityIdentifier("FilterIcon_Nutrition")
        }
        .frame(maxHeight: 44, alignment: .center)
    }
}
