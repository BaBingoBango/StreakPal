//
//  CardBorder.swift
//  StreakPal
//
//  Created by Ethan Marshall on 9/16/26.
//

import SwiftUI

extension View {
    /// The outlined card treatment shared by the home screen's cards.
    func cardBorder(_ style: some ShapeStyle) -> some View {
        overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(style, lineWidth: 3)
        }
    }
}
