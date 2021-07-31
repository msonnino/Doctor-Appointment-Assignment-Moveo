//
//  SignInForm.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 31/07/2021.
//

import SwiftUI

import SwiftUI

struct SignInForm: View {
    
    @Binding var userEmail: String
    @Binding var userPassword: String
    
    var signInButtonFunc: () -> Void
    
    var body: some View {
        
        Form {
            Section(header: Text("Sign in with your details"), content: {
                TextField("Email", text: $userEmail)
                SecureField("Password", text: $userPassword)
                Button(action: {signInButtonFunc()}, label: {
                    Text("Sign In")
                })
            })
           
        }
        
        
    }
}
