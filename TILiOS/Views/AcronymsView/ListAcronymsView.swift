//
//  ListAcronymsView.swift
//  TILiOS
//
//  Created by Rychillie Umpierre de Oliveira on 23/04/25.
//

import SwiftUI

import SwiftUI

struct ListAcronymsView: View {
    @State private var acronyms: [Acronym] = []
    @State private var isLoading = true
    @State private var isAddingAcronym = false
    
    let acronymsRequest = ResourceRequest<Acronym>(resourcePath: "acronyms")
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView()
                } else if acronyms.isEmpty {
                    ContentUnavailableView(
                        "No Acronyms",
                        systemImage: "text.book.closed",
                        description: Text("Start by adding an acronym")
                    )
                } else {
                    List {
                        ForEach(acronyms, id: \.id) { acronym in
                            NavigationLink {
                                DetailAcronymView(acronym: acronym)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(acronym.short)
                                        .font(.headline)
                                    Text(acronym.long)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            deleteAcronyms(at: indexSet)
                        }
                    }
                }
            }
            .navigationTitle("Acronyms")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isAddingAcronym = true
                    }) {
                        Text("Add")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
            }
            .refreshable {
                await refreshAcronyms()
            }
            .sheet(isPresented: $isAddingAcronym) {
                AddAcronymsView(onAdd: {
                    fetchAcronyms()
                })
            }
        }
        .onAppear {
            fetchAcronyms()
        }
    }
    
    private func deleteAcronyms(at offsets: IndexSet) {
        for index in offsets {
            guard let acronymID = acronyms[index].id else { continue }
            let acronymRequest = AcronymRequest(acronymID: acronymID)
            
            acronymRequest.delete()
            acronyms.remove(at: index)
        }
    }
    
    private func fetchAcronyms() {
        acronymsRequest.getAll { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let acronyms):
                    self.acronyms = acronyms
                case .failure:
                    // Handle error here if needed
                    break
                }
            }
        }
    }
    
    @MainActor
    private func refreshAcronyms() async {
        acronymsRequest.getAll { result in
            switch result {
            case .success(let acronyms):
                self.acronyms = acronyms
            case .failure:
                // Handle error here if needed
                break
            }
        }
    }
}

#Preview {
    ListAcronymsView()
}
