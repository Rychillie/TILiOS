//
//  EditAcronymView.swift
//  TILiOS
//
//  Created by Rychillie Umpierre de Oliveira on 24/04/25.
//

import SwiftUI

struct EditAcronymView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var short: String
    @State private var long: String
    @State private var selectedUser: User?
    @State private var isShowingUserPicker = false
    
    let acronym: Acronym
    var onEdit: () -> Void
    
    init(acronym: Acronym, onEdit: @escaping () -> Void) {
        self.acronym = acronym
        self.onEdit = onEdit
        _short = State(initialValue: acronym.short)
        _long = State(initialValue: acronym.long)
    }
    
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
            .navigationTitle("Edit Acronym")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        updateAcronym()
                    }
                    .disabled(!isFormValid)
                }
            }
            .sheet(isPresented: $isShowingUserPicker) {
                SelectUserView(selectedUser: $selectedUser)
            }
        }
        .onAppear {
            fetchCurrentUser()
        }
    }
    
    private func fetchCurrentUser() {
        guard let acronymID = acronym.id else { return }
        
        AcronymRequest(acronymID: acronymID).getUser { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.selectedUser = user
                case .failure:
                    print("Error fetching current user")
                }
            }
        }
    }
    
    private func updateAcronym() {
        guard let user = selectedUser else { return }
        guard let acronymID = acronym.id else { return }
        
        let shortText = short.trim()
        let longText = long.trim()
        
        guard !shortText.isEmpty else {
            print("Short text is empty")
            return
        }
        
        guard !longText.isEmpty else {
            print("Long text is empty")
            return
        }
        
        let updateData = CreateAcronymData(
            short: shortText,
            long: longText,
            userID: user.id!
        )
        
        AcronymRequest(acronymID: acronymID).update(with: updateData) { result in
            switch result {
            case .success:
                onEdit()
                dismiss()
            case .failure:
                print("Error updating acronym")
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
    EditAcronymView(
        acronym: Acronym(
            short: "WWDC",
            long: "Word Wide Developers Conference",
            userID: UUID(
                uuidString: "8b10380b-0859-4b23-8ac0-2b72f289d186"
            )!
        ),
        onEdit: {}
    )
}
