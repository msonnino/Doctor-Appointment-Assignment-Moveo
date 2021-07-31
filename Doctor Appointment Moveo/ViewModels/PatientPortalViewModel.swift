//
//  PatientPortalViewModel.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 31/07/2021.
//

import Foundation

class PatientViewModel: ObservableObject {
    
    // db let's us handle all database requests
    let db = Database.shared
    
    @Published var loggedInPatient: Patient
    @Published var doctorsList: [Doctor]
    @Published var waitlist = [Appointment.PatientDetails]()
    
    // We use a timer to constantly update data
    var timer: Timer?
    
    init(patient: Patient) {
        print("PatientPortalViewModel init")
        self.loggedInPatient = patient
        doctorsList = db.fetchAllDoctors()
        
    }
    
    func creatNewAppointment(doctor: Doctor) {
        
        // Make sure this patient doesn't have an appointment booked already
        if loggedInPatient.appointment == nil {
            
            // We calculate the new appointment's starting time using the chosen doctor's existing appointments list:
            // 1. We calculate the waiting time based on the fixed appointment duration time multiplied by the number of existing appointments in the doctor's list
            let waitingTime = TimeInterval(doctor.appointments.count * Appointment.constantDurationInSeconds)
            // 2. We add this waiting time to the starting time of the doctor's first appointment, and so we know when our appointment will start
            let startingTime = (doctor.appointments.first?.timeStarting ?? Date()) + waitingTime
            
            let newAppointment = Appointment(id: UUID(), patient: loggedInPatient, doctor: doctor, timeCreated: Date(), timeStarting: startingTime)
            if db.createAppointment(appointment: newAppointment) == .failure {
                print("Error creating new appointment")
            }
            
        }
        
        reloadData()
    }
    
    func cancelAppointment() {
        if loggedInPatient.appointment != nil {
            
            // Make sure the appointment hasn't started yet
            let now = Date()
            if now < loggedInPatient.appointment!.timeStarting {
                // The appointment hasn't started - we cancel it
                if db.cancelAppointment(id: loggedInPatient.appointment!.id) == .success {
                    print("Appointment cancelled")
                }
            }
            
        }
        reloadData()
    }
    
    func reloadWaitlist() {
        
        // If the patient has an appointment already booked we want to get the doctor's waitlist

        if loggedInPatient.appointment != nil {
            if var bookedDoctor = db.fetchDoctor(with: loggedInPatient.appointment!.doctorDetails.id) {
                bookedDoctor.appointments.sort(by: {$0.timeCreated < $1.timeCreated})
                waitlist = []
                for appointment in bookedDoctor.appointments {
                    if appointment.timeCreated <= loggedInPatient.appointment!.timeCreated {
                        waitlist.append(appointment.patientDetails)
                    }
                }
            }
        }
    }
    
    
    func reloadData() {
        loggedInPatient = db.fetchPatient(with: loggedInPatient.id)!
        doctorsList = db.fetchAllDoctors()
        reloadWaitlist()
    }
    
    func startUpdatingData() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc func runTimedCode() {
        reloadData()
    }
    
}
