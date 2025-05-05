//
//  ListCategoriesView.swift
//  TILiOS
//
//  Created by Rychillie Umpierre de Oliveira on 23/04/25.
//

import SwiftUI

struct ListCategoriesView: View {
    @State private var categories: [Category] = []
    @State private var isLoading = true
    @State private var isAddingCategory = false
    
    let categoriesRequest = ResourceRequest<Category>(resourcePath: "categories")
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView()
                } else if categories.isEmpty {
                    ContentUnavailableView(
                        "No Categories",
                        systemImage: "tag",
                        description: Text("Start by adding an category")
                    )
                } else {
                    List(categories, id: \.id) { category in
                        VStack(alignment: .leading) {
                            Text(category.name)
                                .font(.headline)
                        }
                    }
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isAddingCategory = true
                    }) {
                        Text("Add")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
            }
            .refreshable {
                await refreshCategories()
            }
            .sheet(isPresented: $isAddingCategory) {
                AddCategoriesView(onAdd: {
                    Task {
                        await refreshCategories()
                    }
                })
            }
        }
        .onAppear {
            fetchCategories()
        }
    }
    
    private func fetchCategories() {
        categoriesRequest.getAll { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let categories):
                    self.categories = categories
                case .failure:
                    // Handle error here if needed
                    break
                }
            }
        }
    }
    
    @MainActor
    private func refreshCategories() async {
        categoriesRequest.getAll { result in
            switch result {
            case .success(let categories):
                self.categories = categories
            case .failure:
                // Handle error here if needed
                break
            }
        }
    }
}

#Preview {
    ListCategoriesView()
}
