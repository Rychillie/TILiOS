//
//  CreateUserData.swift
//  TILiOS
//
//  Created by Rychillie Umpierre de Oliveira on 09/05/25.
//

import Foundation

final class CreateUserData: Codable {
    var id: UUID?
    var name: String
    var username: String
    var password: String?
    
    init(name: String, username: String, password: String) {
        self.name = name
        self.username = username
        self.password = password
    }
}
