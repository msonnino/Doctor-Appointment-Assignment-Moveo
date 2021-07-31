//
//  DoctorPortalViewModel.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 31/07/2021.
//

import Foundation

class DoctorPortalViewModel: ObservableObject {
   
    // db let's us handle all database requests
    let db = Database.shared
    
    @Published var loggedInDoctor: Doctor
    @Published var currentAppointment: Appointment?
    
    // We use a timer to constantly update data
    var timer: Timer?
    
    init(doctor: Doctor) {
        print("DoctorPortalViewModel init")
        self.loggedInDoctor = doctor
        
    }
    
    func reloadCurrentAppointment() {
        if loggedInDoctor.appointments.count > 0 {
            // Make sure to always sort by time created
            loggedInDoctor.appointments.sort(by: {$0.timeCreated < $1.timeCreated} )
            currentAppointment = loggedInDoctor.appointments.first!
        }
    }
    
    func reloadData() {
        loggedInDoctor = db.fetchDoctor(with: loggedInDoctor.id)!
        reloadCurrentAppointment()
    }
    
    func startUpdatingData() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc func runTimedCode() {
        reloadData()
    }
    
}
