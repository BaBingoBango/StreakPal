//
//  UserData.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

import Foundation
import Observation
import OSLog
import UserNotifications

/// The app's single source of truth for reminder settings.
///
/// The model persists itself as JSON in the Documents directory using the same file name and keys
/// the app has always used, so existing installs pick up their settings unchanged. Every change is
/// written immediately, and changes that affect the schedule re-register the local notifications.
@Observable
final class UserData {

    // MARK: Settings

    /// When the first daily reminder fires. Only the hour and minute are used.
    var firstReminderDate: Date { didSet { settingsDidChange(affectsSchedule: true) } }

    /// When the optional second daily reminder fires.
    var secondReminderDate: Date { didSet { settingsDidChange(affectsSchedule: true) } }

    /// Whether the user has completed setup. Reminders are only scheduled once this is true.
    var didSetup: Bool { didSet { settingsDidChange(affectsSchedule: true) } }

    /// Whether tapping a reminder opens Snapchat.
    var sendToSnap: Bool { didSet { settingsDidChange(affectsSchedule: false) } }

    /// Whether to send two reminders a day instead of one.
    var hasTwoReminders: Bool { didSet { settingsDidChange(affectsSchedule: true) } }

    /// Whether the user granted notification permission during setup.
    var wantsNotifications: Bool { didSet { settingsDidChange(affectsSchedule: false) } }

    /// Whether reminders use the Time Sensitive interruption level.
    var isTimeSensitive: Bool { didSet { settingsDidChange(affectsSchedule: true) } }

    // MARK: Lifecycle

    private let fileURL: URL

    /// Loads the settings stored at `fileURL`, falling back to the defaults when the file is missing or unreadable.
    init(fileURL: URL = UserData.defaultFileURL) {
        self.fileURL = fileURL
        let stored = Snapshot.load(from: fileURL) ?? .defaults
        firstReminderDate = stored.firstReminderDate
        secondReminderDate = stored.secondReminderDate
        didSetup = stored.didSetup
        sendToSnap = stored.sendToSnap
        hasTwoReminders = stored.hasTwoReminders
        wantsNotifications = stored.wantsNotifications
        isTimeSensitive = stored.isTimeSensitive
    }

    /// Where the app has always kept its settings: `Documents/UserData.json`.
    static var defaultFileURL: URL {
        URL.documentsDirectory.appending(path: "UserData.json")
    }

    // MARK: Notifications

    /// Asks permission to show alerts and play sounds, recording the answer in ``wantsNotifications``.
    func requestNotificationAuthorization() async {
        do {
            wantsNotifications = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound])
        } catch {
            Self.logger.error("Notification authorization failed: \(error.localizedDescription)")
            wantsNotifications = false
        }
    }

    /// Registers (or refreshes) the repeating daily reminders so they match the current settings.
    /// Does nothing until setup is complete.
    func scheduleReminders() {
        guard didSetup else { return }
        let center = UNUserNotificationCenter.current()

        var requests = [reminderRequest(identifier: Self.firstReminderIdentifier, at: firstReminderDate)]
        if hasTwoReminders {
            requests.append(reminderRequest(identifier: Self.secondReminderIdentifier, at: secondReminderDate))
        } else {
            center.removePendingNotificationRequests(withIdentifiers: [Self.secondReminderIdentifier])
        }

        Task {
            // Re-asserting authorization never prompts again once the user has answered, and it stops
            // scheduling from failing silently when permission was never granted.
            guard (try? await center.requestAuthorization(options: [.alert, .sound])) == true else {
                Self.logger.error("Reminders not scheduled: notifications are not authorized.")
                return
            }
            for request in requests {
                do {
                    try await center.add(request)
                    Self.logger.info("Scheduled \(request.identifier, privacy: .public).")
                } catch {
                    Self.logger.error("Failed to schedule \(request.identifier, privacy: .public): \(error.localizedDescription, privacy: .public)")
                }
            }
        }
    }

    /// Builds the repeating daily notification for a reminder at the hour and minute of `date`.
    func reminderRequest(identifier: String, at date: Date) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "Ding ding! It's streak time!")
        content.body = String(localized: "Send your streaks before it's too late!")
        content.sound = .default
        content.interruptionLevel = isTimeSensitive ? .timeSensitive : .active

        let time = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
        return UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    }

    private static let firstReminderIdentifier = "First Reminder Notification"
    private static let secondReminderIdentifier = "Second Reminder Notification"

    // MARK: Persistence

    private func settingsDidChange(affectsSchedule: Bool) {
        save()
        if affectsSchedule {
            scheduleReminders()
        }
    }

    private func save() {
        let snapshot = Snapshot(
            firstReminderDate: firstReminderDate,
            secondReminderDate: secondReminderDate,
            didSetup: didSetup,
            sendToSnap: sendToSnap,
            hasTwoReminders: hasTwoReminders,
            wantsNotifications: wantsNotifications,
            isTimeSensitive: isTimeSensitive)
        do {
            try JSONEncoder().encode(snapshot).write(to: fileURL, options: .atomic)
        } catch {
            Self.logger.error("Failed to save settings: \(error.localizedDescription)")
        }
    }

    nonisolated private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "StreakPal", category: "UserData")

    /// The on-disk representation. The keys match the original `UserData.json` exactly.
    nonisolated private struct Snapshot: Codable {
        var firstReminderDate: Date
        var secondReminderDate: Date
        var didSetup: Bool
        var sendToSnap: Bool
        var hasTwoReminders: Bool
        var wantsNotifications: Bool
        var isTimeSensitive: Bool

        /// A fresh install's settings: reminders at 10:00 AM and 8:00 PM local time, both on and Time Sensitive.
        static var defaults: Snapshot {
            let calendar = Calendar.current
            let now = Date.now
            return Snapshot(
                firstReminderDate: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now) ?? now,
                secondReminderDate: calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now) ?? now,
                didSetup: false,
                sendToSnap: true,
                hasTwoReminders: true,
                wantsNotifications: false,
                isTimeSensitive: true)
        }

        static func load(from url: URL) -> Snapshot? {
            guard let data = try? Data(contentsOf: url) else { return nil }
            do {
                return try JSONDecoder().decode(Snapshot.self, from: data)
            } catch {
                UserData.logger.error("Ignoring unreadable settings file: \(error.localizedDescription)")
                return nil
            }
        }
    }
}

extension UserData {
    /// A throwaway instance for Xcode previews, backed by a temporary file so real settings are never touched.
    /// Not guarded by `#if DEBUG` because `#Preview` bodies are compiled in Release builds too.
    static func preview(didSetup: Bool = true) -> UserData {
        let fileURL = URL.temporaryDirectory.appending(path: "StreakPalPreview-\(UUID().uuidString).json")
        let userData = UserData(fileURL: fileURL)
        userData.didSetup = didSetup
        return userData
    }
}
