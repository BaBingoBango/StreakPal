//
//  StreakPalUITests.swift
//  StreakPalUITests
//
//  Created by Ethan Marshall on 3/28/20.
//

import XCTest

final class StreakPalUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testHomeScreenOpensSettings() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.navigationBars["StreakPal"].waitForExistence(timeout: 5))

        app.buttons["Settings"].tap()
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 5))
    }

    /// Walks the first-run setup on a fresh install, granting the notification permission, and checks
    /// that the app ends up configured. On an already-configured device it only checks the end state.
    @MainActor
    func testFirstRunSetupConfiguresReminders() throws {
        let app = XCUIApplication()
        app.launch()

        let setupButton = app.buttons["Set Up Reminders…"]
        if setupButton.waitForExistence(timeout: 5) {
            setupButton.tap()
            app.buttons["Set Up Streak Reminders…"].tap()
            XCTAssertTrue(app.buttons["Set Notifications"].waitForExistence(timeout: 5))
            try audit(app)
            // The permission prompt is hosted outside the app and can take a while on a cold simulator.
            // Catch it both ways XCTest offers, then accept either outcome of the permission step.
            let monitor = addUIInterruptionMonitor(withDescription: "Notification permission") { alert in
                alert.buttons["Allow"].tap()
                return true
            }
            app.buttons["Set Notifications"].tap()
            let allow = XCUIApplication(bundleIdentifier: "com.apple.springboard").buttons["Allow"]
            if allow.waitForExistence(timeout: 15) {
                allow.tap()
            }
            app.tap()
            removeUIInterruptionMonitor(monitor)

            let continueButton = app.buttons["Continue"]
            let finishButton = app.buttons["Finish"]
            XCTAssertTrue(continueButton.waitForExistence(timeout: 15) || finishButton.exists,
                          "Setup should move past the permission step")
            if continueButton.exists {
                continueButton.tap()
                XCTAssertTrue(finishButton.waitForExistence(timeout: 5))
                try audit(app)
            }
            finishButton.tap()
            app.buttons["Done"].tap()
        }

        app.buttons["Settings"].tap()
        XCTAssertTrue(app.switches["Two Reminders Per Day"].waitForExistence(timeout: 5))
    }

    /// Runs Xcode's automated accessibility audit on the screens a user reaches in everyday use.
    @MainActor
    func testAccessibilityAuditOfMainScreens() throws {
        let app = XCUIApplication()
        app.launch()
        try audit(app)

        app.buttons["Settings"].tap()
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 5))
        try audit(app)
        app.buttons["Done"].tap()

        app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Snapstreak Tips'")).firstMatch.tap()
        XCTAssertTrue(app.navigationBars["Streak Tips"].waitForExistence(timeout: 5))
        try audit(app)
        app.buttons["Done"].tap()
    }

    /// Runs the accessibility audit for the categories that back the VoiceOver and Voice Control claims:
    /// every element is detected, described, has the right traits, and a usable hit region. Issues are
    /// logged with the element they concern, which the summary in the test report leaves out.
    ///
    /// Three categories are deliberately left out:
    /// - Contrast: the brand orange and the tip headline colors sit below the 4.5:1 guideline in light
    ///   mode by design, so the app does not claim the Sufficient Contrast label.
    /// - Dynamic Type and text clipping: verified by hand at the largest accessibility size instead,
    ///   because the audit's heuristics misreport standard Form rows and decorative emoji.
    @MainActor
    private func audit(_ app: XCUIApplication) throws {
        let categories = XCUIAccessibilityAuditType.all.subtracting([.contrast, .dynamicType, .textClipped])
        try app.performAccessibilityAudit(for: categories) { issue in
            let element = issue.element.map { "\($0)" } ?? "unknown element"
            NSLog("Accessibility audit issue: %@ | %@", issue.detailedDescription, element)
            return false
        }
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
