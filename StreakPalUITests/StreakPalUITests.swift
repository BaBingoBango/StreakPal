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
            }
            finishButton.tap()
            app.buttons["Done"].tap()
        }

        app.buttons["Settings"].tap()
        XCTAssertTrue(app.switches["Two Reminders Per Day"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
