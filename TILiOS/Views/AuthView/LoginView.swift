//
//  LoginView.swift
//  TILiOS
//
//  Created by Rychillie Umpierre de Oliveira on 09/05/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: Auth
    @State private var username = ""
    @State private var password = ""
    @State private var showingLoginError = false
    @State private var loginErrorMessage = "Invalid credentials"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
            .navigationTitle("Login")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        auth.login(username: username, password: password) { result in
                            switch result {
                            case .success:
                                print("Login successful")
                            case .failure:
                                loginErrorMessage = "Failed to login. Please check your credentials."
                                showingLoginError = true
                                print("Login failed")
                            }
                        }
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
            }
            .alert("Login Error", isPresented: $showingLoginError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(loginErrorMessage)
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(Auth())
}
