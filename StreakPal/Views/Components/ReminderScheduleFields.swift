//
//  ReminderScheduleFields.swift
//  StreakPal
//
//  Created by Ethan Marshall on 9/16/26.
//

import SwiftUI

/// The toggle and time pickers that define the daily reminder schedule.
/// Shared by Settings and the setup flow so both edit the same fields the same way.
struct ReminderScheduleFields: View {
    @Environment(UserData.self) private var userData

    var body: some View {
        @Bindable var userData = userData

        Toggle(isOn: $userData.hasTwoReminders) {
            Label("Two Reminders Per Day", systemImage: "bubble.left.and.bubble.right")
        }
        DatePicker(selection: $userData.firstReminderDate, displayedComponents: .hourAndMinute) {
            Label("First Reminder", systemImage: "alarm")
        }
        if userData.hasTwoReminders {
            DatePicker(selection: $userData.secondReminderDate, displayedComponents: .hourAndMinute) {
                Label("Second Reminder", systemImage: "alarm.fill")
            }
        }
    }
}

#Preview {
    Form {
        ReminderScheduleFields()
    }
    .environment(UserData.preview())
}
