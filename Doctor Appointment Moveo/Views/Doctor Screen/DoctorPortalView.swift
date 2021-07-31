//
//  DoctorPortalView.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 31/07/2021.
//

import SwiftUI

struct DoctorPortalView: View {
    
    @ObservedObject var viewModel: DoctorPortalViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    var body: some View {
        
        VStack {
            
            // Doctor icon and name

            VStack {
                HStack(alignment: .top, spacing: 0) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 100))
                    Image(systemName: "cross.circle.fill")
                        .font(.system(size: 40))
                }
                Text("Hello Dr. \(viewModel.loggedInDoctor.fName) \(viewModel.loggedInDoctor.lName)")
                    .font(.title)
            }
            .foregroundColor(.green)
            .padding()
            
            Form {
                
                // If the doctor has an appointment currently booked we show it
                if viewModel.currentAppointment != nil {
                    DoctorCurrentAppointmentSection(currentAppontment: viewModel.currentAppointment!)
                    
                    // If the doctor has more patients on waitlist we show the waitlist
                    if viewModel.loggedInDoctor.appointments.count > 0 {
                        DoctorWaitlistSection(waitlist: viewModel.loggedInDoctor.appointments)
                    }
                    
                }
                
                // Otherwise we tell the doctor he's available
                if viewModel.currentAppointment == nil {
                    Text("You are currently available!")
                }
                
                
            }
            
        }
        .onAppear {
            viewModel.startUpdatingData()
        }
        // Log out button
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing:
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Text("Log Out")
                                }))
        
    }
}

//struct DoctorPortalView_Previews: PreviewProvider {
//    static var previews: some View {
//        DoctorPortalView()
//    }
//}
