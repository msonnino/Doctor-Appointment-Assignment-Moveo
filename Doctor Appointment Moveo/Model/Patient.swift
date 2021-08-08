//
//  Patient.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 30/07/2021.
//

import Foundation

struct Patient: Identifiable {
    let id: UUID
    let fName: String
    let lName: String
    let email: String
    var appointment: Appointment?
}
