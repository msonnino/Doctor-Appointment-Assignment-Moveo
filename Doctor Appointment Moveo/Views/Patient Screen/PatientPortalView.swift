//
//  PatientPortalView.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 31/07/2021.
//

import SwiftUI

struct PatientPortalView: View {
    
    @ObservedObject var viewModel: PatientViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack {
            
            // Patient icon and name
            
            VStack {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 100))
                Text("Hello \(viewModel.loggedInPatient.fName) \(viewModel.loggedInPatient.lName)")
                    .font(.title)
            }
            .foregroundColor(.blue)
            .padding()
            
            Form {
                
                // If the patient doesn't have an appointment already booked we let him choose a doctor and book
                if viewModel.loggedInPatient.appointment == nil {
                    
                    BookingList(doctorsList: viewModel.doctorsList)
                        .environmentObject(viewModel)
                    
                }
                
                // If the patient already has an appointment we give him the option to cancel it and show him the waitlist
                if viewModel.loggedInPatient.appointment != nil {
                    
                    BookedAppointmentSection(appointment: viewModel.loggedInPatient.appointment!, waitlist: viewModel.waitlist)
                        .environmentObject(viewModel)
                    
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

//struct PatientPortalView_Previews: PreviewProvider {
//    static var previews: some View {
//        PatientPortalView()
//    }
//}
