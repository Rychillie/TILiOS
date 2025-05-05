//
//  SelectUserView.swift
//  TILiOS
//
//  Created by Rychillie Umpierre de Oliveira on 24/04/25.
//

import SwiftUI

struct SelectUserView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedUser: User?
    @State private var users: [User] = []
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView()
                } else {
                    Picker("Select User", selection: $selectedUser) {
                        ForEach(users, id: \.id) { user in
                            Text(user.name).tag(user as User?)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }
            }
            .navigationTitle("Select User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
        .onAppear {
            populateUsers()
        }
    }
    
    private func populateUsers() {
        let usersRequest = ResourceRequest<User>(resourcePath: "users")
        
        usersRequest.getAll { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    print("Users fetched successfully: \(users.count)")
                    for user in users {
                        print("User: \(user.name) - \(user.username)")
                    }
                    self.users = users
                    isLoading = false
                case .failure(let error):
                    print("Error fetching users: \(error)")
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    SelectUserView(selectedUser: .constant(nil))
}
