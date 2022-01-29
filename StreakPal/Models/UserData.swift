//
//  UserData.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

//import Foundation
import SwiftUI
import Combine

/// The class responsible for holding the user's data. One instance handles all user data for the app.
final class UserData: ObservableObject, Codable {
    
    // Enumerations
    enum CodingKeys: String, CodingKey {
        case firstReminderDate
        case secondReminderDate
        case didSetup
        case sendToSnap
        case hasTwoReminders
        case wantsNotifications
        case isTimeSensitive
    }
    
    // Variables
    
    // Misc. variables
    
    var timeFormatter: DateFormatter = DateFormatter()
    let didChange = PassthroughSubject<UserData, Never>()
    let content = UNMutableNotificationContent()
    let center = UNUserNotificationCenter.current()
    
    // Notification variables
    
    var firstReminderContent: UNMutableNotificationContent {
        let newContent = UNMutableNotificationContent()
        
        // MARK: Notification settings
        
        newContent.title = "Ding ding! It's streak time!"
        newContent.body = "Send your streaks before it's too late!"
        newContent.sound = UNNotificationSound.default
        if #available(iOS 15.0, *) {
            if isTimeSensitive {
                newContent.interruptionLevel = .timeSensitive
            }
        }
        
        return newContent
    }
    
    var firstReminderTrigger: UNCalendarNotificationTrigger {
        let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: firstReminderDate)
        let newTrigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        return newTrigger
    }
    
    let firstReminderID = "First Reminder Notification"
    
    var firstReminderRequest: UNNotificationRequest {
        return UNNotificationRequest(identifier: firstReminderID, content: firstReminderContent, trigger: firstReminderTrigger)
    }
    
    var secondReminderContent: UNMutableNotificationContent {
        let newContent = UNMutableNotificationContent()
        newContent.title = "Ding ding! It's streak time!"
        newContent.body = "Send your streaks before it's too late!"
        newContent.sound = UNNotificationSound.default
        if #available(iOS 15.0, *) {
            if isTimeSensitive {
                newContent.interruptionLevel = .timeSensitive
            }
        }
        return newContent
    }
    
    var secondReminderTrigger: UNCalendarNotificationTrigger {
        let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: secondReminderDate)
        let newTrigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        return newTrigger
    }
    
    let secondReminderID = "Second Reminder Notification"
    
    var secondReminderRequest: UNNotificationRequest {
        return UNNotificationRequest(identifier: secondReminderID, content: secondReminderContent, trigger: secondReminderTrigger)
    }
    
    // Save data variables
    
    @Published var firstReminderDate: Date {
        didSet {
            didChange.send(self)
            setupNotifs()
        }
    }
    
    @Published var secondReminderDate: Date {
        didSet {
            didChange.send(self)
            setupNotifs()
            
        }
    }
    
    @Published var didSetup: Bool {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var sendToSnap: Bool {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var hasTwoReminders: Bool {
        didSet {
            didChange.send(self)
            setupNotifs()
        }
    }
    
    @Published var wantsNotifications: Bool {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var isTimeSensitive: Bool {
        didSet {
            didChange.send(self)
            setupNotifs()
        }
    }
    
    // Methods
    init() {
        timeFormatter = DateFormatter()
        firstReminderDate = Date(timeIntervalSinceReferenceDate: 54_000) // 10:00 AM
        secondReminderDate = Date(timeIntervalSinceReferenceDate: 90_000) // 8:00 PM
        didSetup = false
        sendToSnap = true
        hasTwoReminders = true
        wantsNotifications = false
        isTimeSensitive = true
    }
    func saveToFile() {
        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = directoryURL.appendingPathComponent("UserData.json")
        let myEncoder = JSONEncoder()
        do {
            let encoded = try? myEncoder.encode(self)
            try encoded?.write(to: fileURL, options: [])
        } catch {
            print("There is an error in the saveToFile() method of UserData.")
        }
    }
    static func getFromFile() -> UserData? {
        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = directoryURL.appendingPathComponent("UserData.json")
        let myDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL, options: [])
            let decoded = try? myDecoder.decode(UserData.self, from: data)
            return decoded!
        } catch {
            print("There is an error in the getFromFile() method of UserData.")
        }
        return UserData()
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstReminderDate, forKey: .firstReminderDate)
        try container.encode(secondReminderDate, forKey: .secondReminderDate)
        try container.encode(didSetup, forKey: .didSetup)
        try container.encode(sendToSnap, forKey: .sendToSnap)
        try container.encode(hasTwoReminders, forKey: .hasTwoReminders)
        try container.encode(wantsNotifications, forKey: .wantsNotifications)
        try container.encode(isTimeSensitive, forKey: .isTimeSensitive)
    }
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        firstReminderDate = try values.decode(Date.self, forKey: .firstReminderDate)
        secondReminderDate = try values.decode(Date.self, forKey: .secondReminderDate)
        didSetup = try values.decode(Bool.self, forKey: .didSetup)
        sendToSnap = try values.decode(Bool.self, forKey: .sendToSnap)
        hasTwoReminders = try values.decode(Bool.self, forKey: .hasTwoReminders)
        wantsNotifications = try values.decode(Bool.self, forKey: .wantsNotifications)
        isTimeSensitive = try values.decode(Bool.self, forKey: .isTimeSensitive)
    }
    func getTimeFormatter() -> DateFormatter {
        timeFormatter.timeStyle = .short
        return timeFormatter
    }
    func setupNotifs() {
        if self.didSetup {
            print("Setting up notifications...")
            if self.hasTwoReminders {
                center.add(self.secondReminderRequest, withCompletionHandler: { (error) in
                    if error != nil {
                        print("There is an error in the setupNotifs() method of MainScreen.swift")
                    }
                })
            } else {
                center.removeAllPendingNotificationRequests()
            }
            
            center.add(self.firstReminderRequest, withCompletionHandler: { (error) in
                if error != nil {
                    print("There is an error in the setupNotifs() method of MainScreen.swift")
                }
            })
        }
    }
}
