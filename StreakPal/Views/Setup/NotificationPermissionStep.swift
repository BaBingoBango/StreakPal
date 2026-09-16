//
//  NotificationPermissionStep.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

import SwiftUI

/// Step one of setup: request permission to send reminders.
struct NotificationPermissionStep: View {
    @Environment(UserData.self) private var userData
    @State private var hasAnswered = false

    /// Completes the whole setup flow.
    let finish: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(message)
                .padding()
            Spacer()
            action
                .buttonStyle(.glassProminent)
                .controlSize(.large)
                .padding()
        }
        .navigationTitle("Allow Notifications")
    }

    private var message: LocalizedStringKey {
        if !hasAnswered {
            return "Allow notifications so StreakPal can remind you to send your streaks!"
        } else if userData.wantsNotifications {
            return "Great! Tap Continue to move on."
        } else {
            return "With notifications off, you will not receive any reminders from StreakPal. You can always head to Settings to re-enable notifications."
        }
    }

    @ViewBuilder
    private var action: some View {
        if !hasAnswered {
            Button {
                Task {
                    await userData.requestNotificationAuthorization()
                    hasAnswered = true
                }
            } label: {
                Text("Set Notifications")
                    .frame(maxWidth: .infinity)
            }
        } else if userData.wantsNotifications {
            NavigationLink {
                ReminderTimesStep(finish: finish)
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
        } else {
            Button(action: finish) {
                Text("Finish")
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    NavigationStack {
        NotificationPermissionStep {}
    }
    .environment(UserData.preview(didSetup: false))
}
