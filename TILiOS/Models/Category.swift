//
//  Category.swift
//  TILiOS
//
//  Created by Rychillie Umpierre de Oliveira on 23/04/25.
//

import Foundation

final class Category: Codable, Hashable {
    var id: UUID?
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
