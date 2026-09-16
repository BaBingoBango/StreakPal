<img src="https://user-images.githubusercontent.com/40375449/182772821-c856f135-1eeb-48b5-9776-5712783d3797.png" alt="StreakPal icon" width="100"/><br>

### StreakPal

An app for setting reminders about [Snapchat Snapstreaks](https://help.snapchat.com/hc/en-us/articles/7012394193684-How-do-Snapstreaks-work-and-when-do-they-expire-)!

- Schedule streak reminders which arrive each day!
- Open Snapchat with a quick tap on reminder push notifications!
- Mark your notifications as Time Sensitive for an extra sense of urgency!

## Quick Start
The app is designed for iOS! To start up the app, you can either download and run the Xcode project or get it right from the [App Store](https://apps.apple.com/app/streakpal/id1587647711)!

Building from source requires Xcode 27. The app runs on iOS 26 and later.

## Under the Hood
StreakPal is a small, fully native SwiftUI app kept current with Apple's latest platform conventions:

- **SwiftUI app lifecycle** with `NavigationStack`, `ShareLink`, and toolbar-driven navigation
- **Observation** (`@Observable`) for the settings model, persisted as JSON in a format that stays compatible with every previous release
- **Swift 6 language mode** with strict concurrency and main-actor default isolation
- **Liquid Glass** controls from the iOS 26 SDK
- **Local notifications** through UserNotifications, including the Time Sensitive interruption level
- **String Catalog** localization, a **privacy manifest**, and a generated Info.plist
- **Swift Testing** unit tests for the settings model, plus XCTest UI tests

## Privacy Policy

To view the privacy policy for the app, please visit the [Privacy Policy page](https://drive.google.com/file/d/1_pU_grtl1SHhvknDzSl6C3Aizm5LPkd4/view?usp=drivesdk).
