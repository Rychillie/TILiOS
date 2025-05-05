//
//  AddToCategoryView.swift
//  TILiOS
//
//  Created by Rychillie Umpierre de Oliveira on 01/05/25.
//

import SwiftUI

struct AddToCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var allCategories: [Category] = []
    @State private var availableCategories: [Category] = []
    @State private var selectedCategories: Set<UUID> = []
    @State private var isLoading = true
    
    let acronym: Acronym
    var onAdd: () -> Void
    
    private let categoriesRequest = ResourceRequest<Category>(resourcePath: "categories")
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView()
                } else if availableCategories.isEmpty {
                    ContentUnavailableView(
                        "No Categories Available",
                        systemImage: "tag",
                        description: Text("All categories have been added to this acronym")
                    )
                } else {
                    List(availableCategories, id: \.id) { category in
                        if let categoryId = category.id {
                            Button(action: {
                                toggleCategory(categoryId)
                            }) {
                                HStack {
                                    Text(category.name)
                                    Spacer()
                                    if selectedCategories.contains(categoryId) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add to Categories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCategories()
                    }
                    .disabled(selectedCategories.isEmpty)
                }
            }
        }
        .onAppear {
            fetchCategories()
        }
    }
    
    private func toggleCategory(_ id: UUID) {
        if selectedCategories.contains(id) {
            selectedCategories.remove(id)
        } else {
            selectedCategories.insert(id)
        }
    }
    
    private func fetchCategories() {
        guard let acronymID = acronym.id else { return }
        let acronymRequest = AcronymRequest(acronymID: acronymID)
        
        // First, fetch current categories of the acronym
        acronymRequest.getCategories { result in
            switch result {
            case .success(let currentCategories):
                // Then fetch all categories
                categoriesRequest.getAll { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let allCategories):
                            self.allCategories = allCategories
                            // Filter out categories that are already added
                            self.availableCategories = allCategories.filter { category in
                                !currentCategories.contains { $0.id == category.id }
                            }
                        case .failure:
                            print("Error fetching categories")
                        }
                        self.isLoading = false
                    }
                }
            case .failure:
                print("Error fetching current categories")
                self.isLoading = false
            }
        }
    }
    
    private func saveCategories() {
        guard let acronymID = acronym.id else { return }
        let acronymRequest = AcronymRequest(acronymID: acronymID)
        
        for category in availableCategories {
            guard let categoryId = category.id else { continue }
            if selectedCategories.contains(categoryId) {
                acronymRequest.add(category: category) { result in
                    switch result {
                    case .success:
                        print("Category added successfully")
                    case .failure:
                        print("Error adding category")
                    }
                }
            }
        }
        
        // Wait a bit for the server to process the changes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            onAdd()
            dismiss()
        }
    }
}

#Preview {
    AddToCategoryView(
        acronym: Acronym(
            short: "TIL",
            long: "Today I Learned",
            userID: UUID()
        ),
        onAdd: {}
    )
}
