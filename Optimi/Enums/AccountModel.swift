//
//  AccountModel.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import Foundation

class AccountModel {
    var accountName: String
    var accountRole: Roles
    
    init(accountName: String = "", accountRole: Roles = Roles.Designer) {
        self.accountName = accountName
        self.accountRole = accountRole
    }
}
