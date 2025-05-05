//
//  AddAcronymsView.swift
//  TILiOS
//
//  Created by Rychillie Umpierre de Oliveira on 23/04/25.
//

import SwiftUI

struct AddAcronymsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var short = ""
    @State private var long = ""
    @State private var selectedUser: User? = nil
    @State private var isShowingUserPicker = false
    
    var onAdd: () -> Void
    
    private var isFormValid: Bool {
        !short.trim().isEmpty &&
        !long.trim().isEmpty &&
        selectedUser != nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Details") {
                    LabeledContent("Acronym") {
                        TextField("Enter acronym", text: $short)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    LabeledContent("Definition") {
                        TextField("Enter definition", text: $long)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    LabeledContent("User") {
                        Text(selectedUser?.name ?? "Select a user")
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(selectedUser == nil ? .secondary : .primary)
                    }
                    .onTapGesture {
                        isShowingUserPicker = true
                    }
                }
            }
            .navigationTitle("New Acronym")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveAcronym()
                    }
                    .disabled(!isFormValid)
                }
            }
            .sheet(isPresented: $isShowingUserPicker) {
                SelectUserView(selectedUser: $selectedUser)
            }
        }
    }
    
    func saveAcronym() {
        let shortText = short.trim()
        let longText = long.trim()
        
        guard !shortText.isEmpty else { return print("Short text is empty") }
        guard !longText.isEmpty else { return print("Long text is empty") }
        guard let userID = selectedUser?.id else { return print("User ID is nil") }
        
        let acronym = Acronym(
            short: shortText,
            long: longText,
            userID: userID
        )
        
        let acronymSaveData = acronym.toCreateData()
        
        ResourceRequest<Acronym>(resourcePath: "acronyms").save(acronymSaveData) { result in
            switch result {
            case .failure:
                print("Error saving acronym")
            case .success:
                onAdd()
                short = ""
                long = ""
                selectedUser = nil
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
    AddAcronymsView(onAdd: {})
}
