//
//  WelcomeViewModel.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 30/07/2021.
//

import Foundation

class WelcomeViewModel: ObservableObject {
    
    // db let's us handle all database requests
    private let db = Database.shared
    
    // Setup notification service
    let notificationService = UserNotificationService.shared

    
    @Published var isLoggedIn = false {
        willSet {
            // isLoggedIn is changed to false when a user logs out so we make sure both loggedInPatient and loggedInDoctor are nil
            if !newValue {
                loggedInPatient = nil
                loggedInDoctor = nil
            }
        }
    }
    
    @Published var userType: UserType = .patient
    
    // we make sure that at any moment there is only one user either a patient or a doctor logged in.
    @Published var loggedInPatient: Patient? = nil {
        willSet {
            if newValue != nil  { loggedInDoctor = nil }
        }
    }
    @Published var loggedInDoctor: Doctor? = nil {
        willSet {
            if newValue != nil { loggedInPatient = nil }
        }
    }
    
    init() {
        
        // Request user notification permissions
        notificationService.requestUserNotificationPermissions()
        
    }
    // deleteAllAppointment for debugging purpose
//    func deleteAllAppointments() {
//        db.deleteAllAppointments()
//    }
    
    //MARK: - Sign In Users
    
    func signInUser(email: String, password: String) {
        switch userType {
        case .patient:
            signInPatient(email: email, password: password)
        case .doctor:
            signInDoctor(email: email, password: password)
        }
    }
    
    private func signInPatient(email: String, password: String) {
        if let approvedPatient = db.authPatient(email: email, password: password) {
            loggedInPatient = approvedPatient
            isLoggedIn = true
            print("Patient signed in")
        }
    }
    
    private func signInDoctor(email: String, password: String) {
        if let approvedDoctor = db.authDoctor(email: email, password: password) {
            loggedInDoctor = approvedDoctor
            isLoggedIn = true
            print("Doctor signed in")
        }
    }
    
    //MARK: - Sign Up Users
    
    func signUpUser(fName: String , lName: String, email: String, password: String) {
        switch userType {
        case .patient:
            signUpPatient(fName: fName, lName: lName, email: email, password: password)
        case .doctor:
            signUpDoctor(fName: fName, lName: lName, email: email, password: password)
        }
    }
    
    private func signUpPatient(fName: String , lName: String, email: String, password: String) {
        let newPatient = Patient(id: UUID(), fName: fName, lName: lName, email: email, appointment: nil)
        if db.createPatient(patient: newPatient, password: password) == .success {
            signInPatient(email: email, password: password)
        }
    }
    
    private func signUpDoctor(fName: String , lName: String, email: String, password: String) {
        let newDoctor = Doctor(id: UUID(), fName: fName, lName: lName, email: email, appointments: [])
        if db.createDoctor(doctor: newDoctor, password: password) == .success{
            signInDoctor(email: email, password: password)
        }
    }
    
    
}
