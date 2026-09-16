//
//  SetupCard.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

import SwiftUI

/// The card shown before setup, inviting the user to configure reminders.
struct SetupCard: View {
    let action: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("No Streak Reminders")
                .font(.headline)
                .textCase(.uppercase)
                .foregroundStyle(.secondary)
            Button(action: action) {
                Text("Set Up Reminders…")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .controlSize(.large)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .cardBorder(Color.accentColor)
    }
}

#Preview {
    SetupCard {}
        .padding()
}
