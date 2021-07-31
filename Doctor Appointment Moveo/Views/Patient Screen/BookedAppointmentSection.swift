//
//  BookedAppointmentSection.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 31/07/2021.
//

import SwiftUI

struct BookedAppointmentSection: View {
    
    @EnvironmentObject var parentViewModel: PatientViewModel
    let appointment: Appointment
    let waitlist: [Appointment.PatientDetails]
    
    var body: some View {
        
        Section(header: Text("Booked Appointment")) {
            Text("You have an appointment booked with Dr. \(appointment.doctorDetails.lName)")
            Button(action: {
                parentViewModel.cancelAppointment()
            }, label: {
                Text("Cancel Appointment")
            }).foregroundColor(.red)
        }
        if waitlist.count > 0 {
            Section(header: Text("Your doctor's current waitlist")) {
                ForEach(waitlist, id: \.id) { patientDetails in
                    Text("\(patientDetails.fName) \(patientDetails.lName)")
                        // We display the patient name in blue the highlight in the list
                        .foregroundColor(patientDetails.id == appointment.patientDetails.id ? .blue : nil)
                }
            }
        }
       
        
    }
}

//struct BookedAppointmentSection_Previews: PreviewProvider {
//    static var previews: some View {
//        BookedAppointmentSection()
//    }
//}
