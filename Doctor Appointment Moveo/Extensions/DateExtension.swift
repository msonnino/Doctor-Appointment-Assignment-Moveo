//
//  DateExtension.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 31/07/2021.
//

import Foundation

extension Date {
    
    func simpleTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
}
