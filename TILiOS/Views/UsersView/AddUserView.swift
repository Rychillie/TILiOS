//
//  AddUserView.swift
//  TILiOS
//
//  Created by Rychillie Umpierre de Oliveira on 23/04/25.
//

import SwiftUI

struct AddUserView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var username = ""
    var onAdd: () -> Void
    
    private var isFormValid: Bool {
        !name.trim().isEmpty && !username.trim().isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    LabeledContent("Name") {
                        TextField("Enter name", text: $name)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    LabeledContent("Username") {
                        TextField("Enter username", text: $username)
                            .multilineTextAlignment(.trailing)
                            .autocapitalization(.none)
                    }
                }
            }
            .navigationTitle("New User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveUser()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    func saveUser() {
        let user = User(name: name, username: username)
        ResourceRequest<User>(resourcePath: "users").save(user) { result in
            switch result {
            case .failure:
                print("Error saving user")
            case .success(let user):
                print("User saved: \(user)")
                onAdd()
                name = ""
                username = ""
                dismiss()
            }
        }
    }
}

private extension String {
    func trim() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

#Preview {
    AddUserView(onAdd: {})
}
