//
//  ContentView.swift
//  TILiOS
//
//  Created by Rychillie Umpierre de Oliveira on 23/04/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ListAcronymsView()
                .tabItem {
                    Label("Acronyms", systemImage: "textformat.characters")
                }

            ListUsersView()
                .tabItem {
                    Label("Users", systemImage: "person.2.fill")
                }
            
            ListCategoriesView()
                .tabItem {
                    Label("Categories", systemImage: "tag.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
