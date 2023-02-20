//
//  Notifications.swift
//  News
//
//  Created by Dmitrii Tikhomirov on 2/19/23.
//

import UIKit

class Notifications: NSObject,  UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    
    //Make badge number = 0 when app is open
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    //Request Authorization
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else { return }
            self.getNotification()
        }
    }
    //Check authorization
    func getNotification() {
        notificationCenter.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
        }
    }
    //Create notification
    func sendNotifications(message: String) {
        let content = UNMutableNotificationContent()
        content.title = "Something went wrong..."
        content.body = message
        content.sound = UNNotificationSound.default
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "Error", content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    //Create Notification Delegate & Functions to see Notifications when app is open
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
