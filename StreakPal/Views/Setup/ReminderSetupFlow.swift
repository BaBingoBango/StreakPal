//
//  ReminderSetupFlow.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

import SwiftUI

/// The first-run flow: ask for notification permission, then choose reminder times.
struct ReminderSetupFlow: View {
    @Environment(UserData.self) private var userData
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            NotificationPermissionStep(finish: finish)
        }
    }

    /// Marks setup complete, which schedules the reminders, and closes the flow.
    private func finish() {
        userData.didSetup = true
        dismiss()
    }
}

#Preview {
    ReminderSetupFlow()
        .environment(UserData.preview(didSetup: false))
}
