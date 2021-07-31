//
//  Doctor.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 30/07/2021.
//

import Foundation

struct Doctor: Identifiable {
    
    let id: UUID
    let fName: String
    let lName: String
    let email: String
    var appointments: [Appointment]
    
    var isAvailable: Bool {
        get {
            return appointments.count == 0
        }
    }
    
}
