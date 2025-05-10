//
//  Token.swift
//  TILiOS
//
//  Created by Rychillie Umpierre de Oliveira on 09/05/25.
//

import Foundation

final class Token: Codable {
    var id: UUID?
    var value: String
    
    init(value: String) {
        self.value = value
    }
}
