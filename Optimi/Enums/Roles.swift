//
//  Roles.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import Foundation

enum Roles: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case Designer
    case Developer
}
