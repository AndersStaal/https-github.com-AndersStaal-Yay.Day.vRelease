//
//  LogInScreen.swift
//  Yay Day
//
//  Created by Anders Staal on 15/01/2025.
//
import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool // Binding to track the login status
    private let signInWithAppleManager = SignInWithAppleManager()

    var body: some View {
        VStack {
            Text("Welcome to Our App!")
                .font(.title)
                .padding()
            
            Button(action: {
                print("Sign In button pressed")
                
                signInWithAppleManager.onSuccess = {
                    // Update the login status when the sign-in is successful
                    print("Sign in success, updating login status")
                    isLoggedIn = true
                }
                signInWithAppleManager.signIn()
            }) {
                Text("Sign In with Apple")
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}
