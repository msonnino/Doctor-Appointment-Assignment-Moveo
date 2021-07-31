//
//  Appointment.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 30/07/2021.
//

import Foundation

struct Appointment: Identifiable {
    
    // Here we can set the standart time for an appointment
    static let constantDurationInSeconds = 30
    
    
    let id: UUID
    let patientDetails: PatientDetails
    let doctorDetails: DoctorDetails
    let timeCreated: Date
    let timeStarting: Date
    
    struct PatientDetails {
        let id: UUID
        let fName: String
        let lName: String
    }
    
    struct DoctorDetails {
        let id: UUID
        let fName: String
        let lName: String
    }
    
    init(id: UUID, patientDetails: PatientDetails, doctorDetails: DoctorDetails, timeCreated: Date, timeStarting: Date) {
        self.id = id
        self.patientDetails = patientDetails
        self.doctorDetails = doctorDetails
        self.timeCreated = timeCreated
        self.timeStarting = timeStarting
    }
    
    init(id: UUID, patient: Patient, doctor: Doctor, timeCreated: Date, timeStarting: Date) {
        self.id = id
        self.patientDetails = PatientDetails(id: patient.id, fName: patient.fName, lName: patient.lName)
        self.doctorDetails = DoctorDetails(id: doctor.id, fName: doctor.fName, lName: doctor.lName)
        self.timeCreated = timeCreated
        self.timeStarting = timeStarting
    }
    
}

