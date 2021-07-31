//
//  UserType.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 30/07/2021.
//

import Foundation

enum UserType {
    case patient
    case doctor
}

extension UserType: CustomStringConvertible {
    var description: String {
        switch self {
        case .patient:
            return "patient"
        case .doctor:
            return "doctor"
        }
    }
}
