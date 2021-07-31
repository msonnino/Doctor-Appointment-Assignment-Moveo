//
//  DoctorCurrentAppointmentSection.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 31/07/2021.
//

import SwiftUI

struct DoctorCurrentAppointmentSection: View {
    
    let currentAppontment: Appointment

    var body: some View {
            
        Section(header: Text("Appointment in session").foregroundColor(.green)) {
            Text("Patient: \(currentAppontment.patientDetails.fName) \(currentAppontment.patientDetails.lName)")
            Text("Started: \(currentAppontment.timeStarting.simpleTimeString())")
        }
        
    }
}

//struct DoctorCurrentAppointmentView_Previews: PreviewProvider {
//    static var previews: some View {
//        DoctorCurrentAppointmentSection()
//    }
//}
