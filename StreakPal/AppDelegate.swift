//
//  AppDelegate.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

import UIKit
import UserNotifications

/// Handles the one job the SwiftUI app lifecycle can't cover on its own: reacting to reminder taps,
/// which requires a `UNUserNotificationCenter` delegate to be in place before the app finishes launching.
final class AppDelegate: NSObject, UIApplicationDelegate {

    /// The app's settings, owned here so notification handling and the SwiftUI scene share one instance.
    let userData = UserData()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        // Keep the pending reminders in sync with the saved settings, so an app update or reinstall
        // can never leave the schedule stale or unregistered.
        userData.scheduleReminders()
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    /// Shows a reminder even while StreakPal is in the foreground. Without this, the system drops
    /// notifications that arrive while the app is on screen.
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .list, .sound]
    }

    /// Called when the user taps a reminder. Opens Snapchat, or its website when the app isn't installed,
    /// if the "Open Snapchat on Tap" setting is on.
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        await openSnapchatIfEnabled()
    }

    private func openSnapchatIfEnabled() async {
        guard userData.sendToSnap else { return }
        let application = UIApplication.shared
        if await application.open(Self.snapchatAppURL) == false {
            _ = await application.open(Self.snapchatWebsiteURL)
        }
    }

    private static let snapchatAppURL = URL(string: "snapchat://")!
    private static let snapchatWebsiteURL = URL(string: "https://www.snapchat.com/")!
}
