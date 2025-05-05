//
//  AddCategoriesView.swift
//  TILiOS
//
//  Created by Rychillie Umpierre de Oliveira on 01/05/25.
//

import SwiftUI

struct AddCategoriesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    
    var onAdd: () -> Void
    
    private var isFormValid: Bool {
        !name.trim().isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Details") {
                    LabeledContent("Name") {
                        TextField("Enter category name", text: $name)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .navigationTitle("New Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCategory()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    func saveCategory() {
        let nameText = name.trim()
        guard !nameText.isEmpty else { return print("Name is empty") }
        
        let category = Category(name: nameText)
        
        ResourceRequest<Category>(resourcePath: "categories").save(category) { result in
            switch result {
            case .failure:
                print("Error saving category")
            case .success:
                onAdd()
                name = ""
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
    AddCategoriesView(onAdd: {})
}
