//
//  MainScreen.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

import SwiftUI

/// The home screen: the reminder summary card plus the app's quick actions.
struct MainScreen: View {
    @Environment(UserData.self) private var userData
    @State private var isShowingSettings = false
    @State private var isShowingTips = false
    @State private var strongMessage = StrongMessages.random()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if userData.didSetup {
                        ReminderCard()
                    } else {
                        SetupCard { isShowingSettings = true }
                    }

                    ShareLink(item: strongMessage) {
                        FeatureCard(
                            emoji: "⏳",
                            title: "About to lose your streaks?",
                            description: "Never fear! Tap here to send your friends a strongly worded message encouraging them to snap you back!")
                    }
                    .buttonStyle(.plain)
                    // Line up a fresh message for the next share; the tap that just happened keeps the current one.
                    .simultaneousGesture(TapGesture().onEnded { strongMessage = StrongMessages.random() })

                    Button {
                        isShowingTips = true
                    } label: {
                        FeatureCard(
                            emoji: "💡",
                            title: "Snapstreak Tips!",
                            description: "Check here for some useful tricks for making sure you never lose your streaks.")
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                .frame(maxWidth: 640)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("StreakPal")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Settings", systemImage: "gearshape") {
                        isShowingSettings = true
                    }
                }
            }
            .sheet(isPresented: $isShowingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $isShowingTips) {
                TipsView()
            }
        }
    }
}

#Preview("Reminders set up") {
    MainScreen()
        .environment(UserData.preview(didSetup: true))
}

#Preview("Fresh install") {
    MainScreen()
        .environment(UserData.preview(didSetup: false))
}
