//
//  GeneralController.swift
//  Optimi
//
//  Created by Pedro Pessuto on 08/04/24.
//

import Foundation
import CloudKit


@Observable class GeneralController {
        
    var tasks: [TaskModel] = []
    
    init(tasks: [TaskModel] = []) {
        self.tasks = tasks
    }
}
