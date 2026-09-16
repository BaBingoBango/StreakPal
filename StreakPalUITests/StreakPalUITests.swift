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

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
