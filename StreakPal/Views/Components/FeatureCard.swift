//
//  FeatureCard.swift
//  StreakPal
//
//  Created by Ethan Marshall on 9/16/26.
//

import SwiftUI

/// A tappable card with an emoji, a headline, and a short description.
struct FeatureCard: View {
    let emoji: String
    let title: LocalizedStringKey
    let description: LocalizedStringKey

    var body: some View {
        HStack(spacing: 16) {
            Text(emoji)
                .font(.largeTitle)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.leading)
            Spacer(minLength: 0)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBorder(.tertiary)
        .contentShape(.rect)
    }
}

#Preview {
    FeatureCard(
        emoji: "💡",
        title: "Snapstreak Tips!",
        description: "Check here for some useful tricks for making sure you never lose your streaks.")
    .padding()
}
