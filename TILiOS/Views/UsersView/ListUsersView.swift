//
//  ListUsersView.swift
//  TILiOS
//
//  Created by Rychillie Umpierre de Oliveira on 23/04/25.
//

import SwiftUI

struct ListUsersView: View {
    @State private var users: [User] = []
    @State private var isLoading = true
    @State private var isAddingUser = false
    
    let usersRequest = ResourceRequest<User>(resourcePath: "users")
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView()
                } else if users.isEmpty {
                    ContentUnavailableView(
                        "No Users",
                        systemImage: "person",
                        description: Text("Start by adding an user")
                    )
                } else {
                    List(users, id: \.id) { user in
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.headline)
                            Text(user.username)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isAddingUser = true
                    }) {
                        Text("Add")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
            }
            .refreshable {
                fetchUsers()
            }
            .sheet(isPresented: $isAddingUser) {
                AddUserView(onAdd: {
                    fetchUsers()
                })
            }
        }
        .onAppear {
            fetchUsers()
        }
    }
    
    private func fetchUsers() {
        usersRequest.getAll { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let users):
                    self.users = users
                case .failure:
                    // Handle error here if needed
                    break
                }
            }
        }
    }
}

#Preview {
    ListUsersView()
}
