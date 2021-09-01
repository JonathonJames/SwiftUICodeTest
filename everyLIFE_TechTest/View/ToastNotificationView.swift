//
//  ToastNotificationView.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 01/09/2021.
//

import SwiftUI

/// A view representing a 'toast' UI element.
struct ToastNotificationView: View {
    
    let toastColor: Color
    let text: String
    let textColor: Color
    
    init(color: Color = .red, text: String, textColor: Color = .white) {
        self.toastColor = color
        self.text = text
        self.textColor = textColor
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(self.toastColor)
            Text(self.text)
                .foregroundColor(self.textColor)
        }
        .frame(maxWidth: .infinity, maxHeight: 40, alignment:  .center)
        .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
    }
}



