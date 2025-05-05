//
//  DetailAcronymView.swift
//  TILiOS
//
//  Created by Rychillie Umpierre de Oliveira on 24/04/25.
//

import SwiftUI

struct DetailAcronymView: View {
    let acronym: Acronym
    @State private var user: User?
    @State private var categories: [Category] = []
    @State private var isLoading = true
    @State private var isEditingAcronym = false
    @State private var isAddingToCategory = false
    
    var body: some View {
        List {
            Section("Details") {
                LabeledContent("Acronym", value: acronym.short)
                LabeledContent("Definition", value: acronym.long)
            }
            
            Section("User") {
                if isLoading {
                    ProgressView()
                } else if let user = user {
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)
                        Text(user.username)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Section("Categories") {
                if isLoading {
                    ProgressView()
                } else if categories.isEmpty {
                    ContentUnavailableView(
                        "No Categories",
                        systemImage: "tag",
                        description: Text("This acronym has no categories")
                    )
                } else {
                    ForEach(categories, id: \.id) { category in
                        Text(category.name)
                    }
                }
            }
        }
        .navigationTitle(acronym.short)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        isEditingAcronym = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button {
                        isAddingToCategory = true
                    } label: {
                        Label("Add to Category", systemImage: "tag")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $isEditingAcronym) {
            EditAcronymView(acronym: acronym, onEdit: {
                fetchDetails()
            })
        }
        .sheet(isPresented: $isAddingToCategory) {
            AddToCategoryView(acronym: acronym) {
                Task {
                    await refreshDetails()
                }
            }
        }
        .onAppear {
            fetchDetails()
        }
    }
    
    private func fetchDetails() {
        guard let acronymID = acronym.id else { return }
        let acronymRequest = AcronymRequest(acronymID: acronymID)
        
        // Fetch user
        acronymRequest.getUser { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                case .failure:
                    print("Error fetching user")
                }
            }
        }
        
        // Fetch categories
        acronymRequest.getCategories { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self.categories = categories
                case .failure:
                    print("Error fetching categories")
                }
                self.isLoading = false
            }
        }
    }
    
    @MainActor
    private func refreshDetails() async {
        isLoading = true
        fetchDetails()
    }
}

#Preview {
    DetailAcronymView(
        acronym: Acronym(
            short: "WWDC",
            long: "Word Wide Developers Conference",
            userID: UUID(
                uuidString: "8b10380b-0859-4b23-8ac0-2b72f289d186"
            )!
        )
    )
}
