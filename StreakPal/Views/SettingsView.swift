//
//  SettingsView.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

import SwiftUI

/// Reminder, notification, and app information settings, presented as a sheet.
struct SettingsView: View {
    @Environment(UserData.self) private var userData
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @State private var isShowingSetup = false
    @State private var isShowingFeedbackFallback = false

    private static let privacyPolicyURL = URL(string: "https://drive.google.com/open?id=1_pU_grtl1SHhvknDzSl6C3Aizm5LPkd4")!

    var body: some View {
        @Bindable var userData = userData

        NavigationStack {
            Form {
                if userData.didSetup {
                    Section("Streak Reminders") {
                        ReminderScheduleFields()
                    }
                    Section("Notifications") {
                        Toggle(isOn: $userData.sendToSnap) {
                            Label("Open Snapchat on Tap", systemImage: "arrowshape.turn.up.right.fill")
                        }
                        Toggle(isOn: $userData.isTimeSensitive) {
                            Label("Mark as Time Sensitive", systemImage: "clock.badge.exclamationmark.fill")
                        }
                    }
                } else {
                    Section("Streak Reminders") {
                        Button {
                            isShowingSetup = true
                        } label: {
                            Label("Set Up Streak Reminders…", systemImage: "arrow.up.right")
                        }
                    }
                }

                Section("Information") {
                    LabeledContent("Version", value: Bundle.main.versionDescription)
                    Link(destination: Self.privacyPolicyURL) {
                        Label("View Privacy Policy", systemImage: "hand.raised.fill")
                    }
                    Button {
                        // Opens the user's default mail app; falls back to an alert if none can handle mailto.
                        openURL(FeedbackEmail.url) { accepted in
                            isShowingFeedbackFallback = !accepted
                        }
                    } label: {
                        Label("Send Feedback", systemImage: "envelope.fill")
                    }
                }
            }
            .alert("No Mail App Found", isPresented: $isShowingFeedbackFallback) {
                Button("Copy Email Address") {
                    UIPasteboard.general.string = FeedbackEmail.address
                }
                Button("OK", role: .cancel) {}
            } message: {
                Text("You can send feedback to \(FeedbackEmail.address).")
            }
            .animation(.default, value: userData.hasTwoReminders)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $isShowingSetup) {
                ReminderSetupFlow()
            }
        }
    }
}

#Preview("Reminders set up") {
    SettingsView()
        .environment(UserData.preview(didSetup: true))
}

#Preview("Fresh install") {
    SettingsView()
        .environment(UserData.preview(didSetup: false))
}
