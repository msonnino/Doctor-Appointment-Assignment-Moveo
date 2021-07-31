//
//  UserNotificationService.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 31/07/2021.
//

import Foundation
import UserNotifications

struct UserNotificationService {
    
    static let shared = UserNotificationService()

    func requestUserNotificationPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                print("Error requesting notification permissions: \(error)")
            }
            
            // Enable or disable features based on the authorization.
        }
    }
    
}
