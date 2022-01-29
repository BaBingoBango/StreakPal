//
//  AppDelegate.swift
//  StreakPal
//
//  Created by Ethan Marshall on 3/28/20.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var userData: UserData = UserData()
    
    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // MARK: App Launch Code
        
        // Read save data
        if let dataFromFile = UserData.getFromFile() {
            print("Reading data...")
            userData = dataFromFile
        } else {
            userData = UserData()
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        return true
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        // MARK: App Termination Code
        
        // Save the data
        print("Saving data...")
        AppDelegate.shared().userData.saveToFile()
        
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
extension AppDelegate: UNUserNotificationCenterDelegate {
// This function will be called right after user taps on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // MARK: Notification handler
        
        print("Handling notification...")
        
        if userData.sendToSnap {
            let snapchatHooks = "snapchat://"
            let snapchatURL = NSURL(string: snapchatHooks)
            if UIApplication.shared.canOpenURL(snapchatURL! as URL) {
                print("Opening snap...")
                UIApplication.shared.open(snapchatURL! as URL)
            } else {
                print("Opening snapchat.com...")
                UIApplication.shared.open(NSURL(string: "http://snapchat.com/")! as URL)
            }
        }
        
      completionHandler()
    }
    
}

