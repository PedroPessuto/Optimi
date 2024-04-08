//
//  DatabaseController.swift
//  Optimi
//
//  Created by Pedro Pessuto on 08/04/24.
//

import Foundation
import CloudKit


@Observable class DatabaseController {
        
    var tasks: [TaskModel] = []
    
    init(tasks: [TaskModel] = []) {
        self.tasks = tasks
    }
}
