//
//  FilterIcon.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 01/09/2021.
//

import SwiftUI

/// An icon for use within a `FilterView`
struct FilterIcon: View {
    
    let imageName: String
    let isActive: Bool
    
    var body: some View {
        if self.isActive {
            Image(self.imageName)
        } else {
            Image(self.imageName)
                .renderingMode(.template)
                .foregroundColor(.gray)
        }
        
    }
}

