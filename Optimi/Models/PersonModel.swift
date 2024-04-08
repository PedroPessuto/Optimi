//
//  PersonModel.swift
//  Optimi
//
//  Created by Pedro Pessuto on 08/04/24.
//

import Foundation
import SwiftData

@Model
class PersonModel: Hashable {
    var personId: String = "\(UUID())"
    var personName: String = ""
   
    init(personId: String = "", personName: String = "") {
        self.personId = personId
        self.personName = personName
    }
}
