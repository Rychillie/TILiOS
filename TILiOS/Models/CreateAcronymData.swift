//
//  CreateAcronymData.swift
//  TILiOS
//
//  Created by Rychillie Umpierre de Oliveira on 23/04/25.
//

import Foundation

struct CreateAcronymData: Codable {
    let short: String
    let long: String
    let userID: UUID
}

extension Acronym {
    func toCreateData() -> CreateAcronymData {
        CreateAcronymData(short: self.short, long: self.long, userID: self.user.id)
    }
}
