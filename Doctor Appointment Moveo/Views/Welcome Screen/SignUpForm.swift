//
//  SignUpForm.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 31/07/2021.
//

import SwiftUI

struct SignUpForm: View {
    
    @State var fName: String = ""
    @State var lName: String = ""
    @State var userEmail: String = ""
    @State var userPassword: String = ""
    @State var userPasswordRepeat: String = ""
    @Binding var showSignUpPopup: Bool
    @State var isPassowrdMatch: Bool = true
    
    var signUpFunc: (_ fName: String, _ lName: String, _ email: String, _ password: String) -> Void
    
    var body: some View {
        
        NavigationView {
            Form {
                
                Section{
                    TextField("First Name", text: $fName)
                    TextField("Last Name", text: $lName)
                }
                
                Section(
                    footer: Text("Password doesn't match")
                            .foregroundColor(.red)
                            .opacity(isPassowrdMatch ? 0 : 1)
                ) {
                    TextField("Email", text: $userEmail)
                    SecureField("Password", text: $userPassword)
                    SecureField("Repeat Password", text: $userPasswordRepeat)
                        .onChange(of: userPasswordRepeat, perform: { value in
                            isPassowrdMatch = true
                        })
                }
                
                Section {
                    Button(action: {
                        // We check to see that the passwords match
                        if userPassword != userPasswordRepeat {
                            isPassowrdMatch = false
                        } else {
                            // If passwords match we sign up and dismiss the sheet
                            signUpFunc(fName, lName, userEmail, userPassword)
                            showSignUpPopup = false
                        }
                    }, label: {
                        Text("Sign Up")
                    })
                }
                
            }.navigationTitle("Sign Up")
        }
        
    }
}
