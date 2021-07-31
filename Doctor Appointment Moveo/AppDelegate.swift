//
//  AppDelegate.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 30/07/2021.
//

import Foundation
import SwiftUI
import UserNotifications

// We need the AppDelegate so we can recieve notifications when the app is in the foreground
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Here we handle the notification
        print("Notification received with identifier \(notification.request.identifier)")
        completionHandler([.banner, .sound])
    }
}
