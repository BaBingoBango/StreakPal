//
//  ReminderTimesStep.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

import SwiftUI

/// Step two of setup: choose when the reminders arrive.
struct ReminderTimesStep: View {
    @Environment(UserData.self) private var userData

    /// Completes the whole setup flow.
    let finish: () -> Void

    var body: some View {
        Form {
            Section {
                Text("When would you like to be reminded to send your streaks? StreakPal recommends two reminders per day.")
            }
            Section {
                ReminderScheduleFields()
            }
        }
        .animation(.default, value: userData.hasTwoReminders)
        .safeAreaBar(edge: .bottom) {
            Button(action: finish) {
                Text("Finish")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .controlSize(.large)
            .padding()
        }
        .navigationTitle("Set Reminder Times")
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack {
        ReminderTimesStep {}
    }
    .environment(UserData.preview(didSetup: false))
}
