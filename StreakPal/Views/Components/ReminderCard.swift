//
//  ReminderCard.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

import SwiftUI

/// Shows the reminder times the user has chosen.
struct ReminderCard: View {
    @Environment(UserData.self) private var userData

    var body: some View {
        VStack(spacing: 6) {
            Text("Streak Reminders")
                .font(.headline)
                .textCase(.uppercase)
                .foregroundStyle(.secondary)
            Text(userData.firstReminderDate, format: .dateTime.hour().minute())
                .font(.title.weight(.black))
            if userData.hasTwoReminders {
                Text("and")
                    .font(.caption)
                    .textCase(.uppercase)
                    .foregroundStyle(.secondary)
                Text(userData.secondReminderDate, format: .dateTime.hour().minute())
                    .font(.title.weight(.black))
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .cardBorder(Color.accentColor)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ReminderCard()
        .environment(UserData.preview())
        .padding()
}
