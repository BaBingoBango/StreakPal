//
//  StreakPalApp.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

import SwiftUI

@main
struct StreakPalApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environment(appDelegate.userData)
        }
    }
}
