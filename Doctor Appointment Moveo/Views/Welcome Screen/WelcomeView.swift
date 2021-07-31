//
//  WelcomeView.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 30/07/2021.
//

import SwiftUI
import CoreData

struct WelcomeView: View {
    
    @ObservedObject var viewModel: WelcomeViewModel
    @State var userType: UserType = .patient
    @State var userEmail: String = ""
    @State var userPassword: String = ""
    @State var showSignUpPopup: Bool = false

    // "selection" triggers the relavant NavigationLink when a user logs in.
    @State var selection: Int?
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // Picker to switch between user types
                
                Picker(selection: $userType, label: Text("Picker"), content: {
                    Text("Patient").tag(UserType.patient)
                    Text("Doctor").tag(UserType.doctor)
                })
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: userType, perform: { value in
                    userEmail = ""
                    userPassword = ""
                    viewModel.userType = value
                })
                
                // User type indication icon
                
                VStack {
                    HStack(alignment: .top, spacing: 0) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 100))
                        if (userType == .doctor) {
                            Image(systemName: "cross.circle.fill")
                                .font(.system(size: 40))
                        }
                    }
                    Text("Log in as a \(viewModel.userType.description.capitalized)")
                        .font(.title)
                }.padding()
                
                // Log In Form
                
                SignInForm(userEmail: $userEmail, userPassword: $userPassword, signInButtonFunc: signIn)
                
                // Sign Up
                
                Form {
                    Section(header: Text("or register a new user")) {
                        Button(action: {showSignUpPopup = true}, label: {
                            Text("Sign Up")
                        })
                    }
                }
                .sheet(isPresented: $showSignUpPopup) {
                    SignUpForm(showSignUpPopup: $showSignUpPopup, signUpFunc: signUp)
                }
                
                // Navigation links
                
                if userType == .patient {
                    // NavigationLink to patient's portal
                    if viewModel.loggedInPatient != nil {
                        NavigationLink(
                            destination: PatientPortalView(viewModel: PatientViewModel(patient: viewModel.loggedInPatient!)),
                            tag: 1,
                            selection: $selection,
                            label: {Text("")})
                            .hidden()
                    }
                }
                if userType == .doctor {
                    // NavigationLink to doctor's portal
                    if viewModel.loggedInDoctor != nil {
                        NavigationLink(
                            destination: DoctorPortalView(viewModel: DoctorPortalViewModel(doctor: viewModel.loggedInDoctor!)),
                            tag: 1,
                            selection: $selection,
                            label: {Text("")})
                            .hidden()
                    }
                }
                
                // "Delete all appointments" button for debugging purpose
//                Button(action: {viewModel.deleteAllAppointments()}, label: {
//                    Text("Delete all appointments")
//                })
                
            }
            .onAppear {
                userType = viewModel.userType
                viewModel.isLoggedIn = false
            }
            .foregroundColor((userType == .patient) ? .blue : .green)
            .navigationTitle("Appointment Manager")
            .onChange(of: viewModel.isLoggedIn, perform: { value in
                if value {
                    selection = 1
                }
            })
            
        }
    }
    
    
    //MARK: - User Intents
    
    func signIn() {
        viewModel.signInUser(email: userEmail.lowercased(), password: userPassword)
    }
    
    func signUp(fName: String , lName: String, email: String, password: String) {
        viewModel.signUpUser(fName: fName.capitalized, lName: lName.capitalized, email: email.lowercased(), password: password)
    }
    
}
