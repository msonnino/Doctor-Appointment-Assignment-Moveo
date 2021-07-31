//
//  Doctor_Appointment_MoveoApp.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 30/07/2021.
//

import SwiftUI

@main
struct Doctor_Appointment_MoveoApp: App {
    
    // We need the AppDelegate so we can recieve notifications when the app is in the foreground
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            WelcomeView(viewModel: WelcomeViewModel())
        }
    }
    
    
}
