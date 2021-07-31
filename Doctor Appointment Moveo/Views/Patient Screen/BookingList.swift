//
//  BookingList.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 31/07/2021.
//

import SwiftUI

struct BookingList: View {
    
    @EnvironmentObject var parentViewModel: PatientViewModel
    
    let doctorsList: [Doctor]
    @State var showAvailableOnly = true
    @State var showBookingAlert: Bool = false
    @State var selectedDoctor: Doctor?

    
    var body: some View {
        
        Section(header: Text("Book An Appointment")) {
            Toggle(isOn: $showAvailableOnly) {
                Text("Show available doctors only ")
            }
            
            List {
                ForEach(doctorsList) { doctor in
                    if (!showAvailableOnly || doctor.isAvailable) {
                        Text("Dr. \(doctor.fName) \(doctor.lName)")
                            .onTapGesture {
                                print(doctor.isAvailable)
                                selectedDoctor = doctor
                                showBookingAlert = true
                            }
                    }
                }
            }
        }
        .alert(isPresented: $showBookingAlert, content: {
            Alert(title: Text("Book an appointment"),
                  message: Text("Would you like to book an appointment with Dr. \(selectedDoctor?.lName ?? "")"),
                  primaryButton: .default(Text("OK"), action: {
                    if selectedDoctor != nil {
                        createAppointment(with: selectedDoctor!)
                    }
                  }), secondaryButton: .cancel())
        })
        
        
    }
    
    func createAppointment(with doctor: Doctor) {
        parentViewModel.creatNewAppointment(doctor: doctor)
    }
}

//struct BookingForm_Previews: PreviewProvider {
//    static var previews: some View {
//        BookingForm()
//    }
//}
