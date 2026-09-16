//
//  StreakPalTests.swift
//  StreakPalTests
//
//  Created by Ethan Marshall on 3/28/20.
//

import Foundation
import Testing
import UserNotifications
@testable import StreakPal

@MainActor
struct UserDataTests {

    /// A throwaway settings file so tests never touch real user data.
    private let fileURL = URL.temporaryDirectory.appending(path: "StreakPalTests-\(UUID().uuidString).json")

    @Test func freshInstallStartsWithTwoDailyReminders() {
        let userData = UserData(fileURL: fileURL)

        #expect(userData.didSetup == false)
        #expect(userData.wantsNotifications == false)
        #expect(userData.hasTwoReminders)
        #expect(userData.sendToSnap)
        #expect(userData.isTimeSensitive)

        let calendar = Calendar.current
        #expect(calendar.component(.hour, from: userData.firstReminderDate) == 10)
        #expect(calendar.component(.hour, from: userData.secondReminderDate) == 20)
    }

    @Test func changesAreSavedImmediatelyAndReloaded() {
        let original = UserData(fileURL: fileURL)
        original.hasTwoReminders = false
        original.sendToSnap = false
        original.isTimeSensitive = false
        original.firstReminderDate = Date(timeIntervalSinceReferenceDate: 12_345)

        let reloaded = UserData(fileURL: fileURL)
        #expect(reloaded.hasTwoReminders == false)
        #expect(reloaded.sendToSnap == false)
        #expect(reloaded.isTimeSensitive == false)
        #expect(reloaded.firstReminderDate == Date(timeIntervalSinceReferenceDate: 12_345))
    }

    @Test func settingsWrittenByTheOriginalAppStillLoad() throws {
        // The exact JSON the 2021 release wrote: dates as seconds since the reference date.
        let legacyJSON = """
        {"firstReminderDate":54000,"secondReminderDate":90000,"didSetup":true,"sendToSnap":false,\
        "hasTwoReminders":false,"wantsNotifications":true,"isTimeSensitive":false}
        """
        try Data(legacyJSON.utf8).write(to: fileURL)

        let userData = UserData(fileURL: fileURL)
        #expect(userData.didSetup)
        #expect(userData.wantsNotifications)
        #expect(userData.sendToSnap == false)
        #expect(userData.hasTwoReminders == false)
        #expect(userData.isTimeSensitive == false)
        #expect(userData.firstReminderDate == Date(timeIntervalSinceReferenceDate: 54_000))
        #expect(userData.secondReminderDate == Date(timeIntervalSinceReferenceDate: 90_000))
    }

    @Test func unreadableSettingsFallBackToDefaults() throws {
        try Data("definitely not JSON".utf8).write(to: fileURL)

        let userData = UserData(fileURL: fileURL)
        #expect(userData.didSetup == false)
        #expect(userData.hasTwoReminders)
    }

    @Test func reminderRepeatsDailyAtTheChosenTime() throws {
        let userData = UserData(fileURL: fileURL)
        let eightThirty = try #require(Calendar.current.date(bySettingHour: 20, minute: 30, second: 0, of: .now))

        let request = userData.reminderRequest(identifier: "test", at: eightThirty)
        let trigger = try #require(request.trigger as? UNCalendarNotificationTrigger)

        #expect(trigger.repeats)
        #expect(trigger.dateComponents.hour == 20)
        #expect(trigger.dateComponents.minute == 30)
        #expect(request.content.interruptionLevel == .timeSensitive)
    }

    @Test func reminderRespectsTimeSensitiveSetting() {
        let userData = UserData(fileURL: fileURL)
        userData.isTimeSensitive = false

        let request = userData.reminderRequest(identifier: "test", at: .now)
        #expect(request.content.interruptionLevel == .active)
    }
}

struct StrongMessagesTests {

    @Test func everyMessageIsShareable() {
        #expect(!StrongMessages.all.isEmpty)
        #expect(StrongMessages.all.allSatisfy { !$0.isEmpty })
    }

    @Test func randomMessageComesFromTheList() {
        #expect(StrongMessages.all.contains(StrongMessages.random()))
    }
}
