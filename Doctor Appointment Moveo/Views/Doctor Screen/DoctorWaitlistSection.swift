//
//  DoctorWaitlistSection.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 31/07/2021.
//

import SwiftUI

struct DoctorWaitlistSection: View {
    
    var waitlist: [Appointment]
    
    var body: some View {
        
        // Just to be safe we make sure (again) that waitlist contains more than 1 element
        if waitlist.count >= 1 {
            Section(header: Text("Your current waitlist")) {
                
                List {
                    ForEach(waitlist[1...]) { appointment in
                        Text("\(appointment.patientDetails.fName) \(appointment.patientDetails.lName)")
                    }
                }
                
            }
        }
        
    }
}

//struct DoctorWaitlistSection_Previews: PreviewProvider {
//    static var previews: some View {
//        DoctorWaitlistSection()
//    }
//}
