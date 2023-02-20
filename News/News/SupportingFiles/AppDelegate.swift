//
//  AppDelegate.swift
//  News
//
//  Created by Dmitrii Tikhomirov on 2/10/23.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let notifications = Notifications()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navController = UINavigationController.init(rootViewController: NewsViewController())
        //Create a window that is the same size as the screen
        window = UIWindow(frame: UIScreen.main.bounds)
        //Assign the view controller as `window`'s root view controller with NavigationController
        window?.rootViewController = navController
        //Show the window
        window?.makeKeyAndVisible()
        //Create request for notification user
        notifications.requestAuthorization()
        notifications.notificationCenter.delegate = notifications
        
        return true
    }
    
}
