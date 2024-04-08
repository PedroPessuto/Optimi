//
//  ProjectModel.swift
//  Optimi
//
//  Created by Pedro Pessuto on 08/04/24.
//

import Foundation
import SwiftData

@Model
class ProjectModel {
    var projectName: String = ""
    var projectKey: String = ""
    var projectCreatedAt: Date = Date()
    
    @Relationship(deleteRule: .cascade) var projectTasks: [TaskModel]? = nil
    
    private func genereteKey() -> String {
        var baseIntA = Int(arc4random() % 65535)
        var baseIntB = Int(arc4random() % 65535)
        var str = String(format: "%06X%06X", baseIntA, baseIntB)
        baseIntA = Int(arc4random() % 65535)
        baseIntB = Int(arc4random() % 65535)
        str = str + "-" + String(format: "%06X%06X", baseIntA, baseIntB)
        baseIntA = Int(arc4random() % 65535)
        baseIntB = Int(arc4random() % 65535)
        str = str + "-" + String(format: "%06X%06X", baseIntA, baseIntB)
        baseIntA = Int(arc4random() % 65535)
        baseIntB = Int(arc4random() % 65535)
        str = str + "-" + String(format: "%06X%06X", baseIntA, baseIntB)
        return str
    }
    
    init(projectName: String, projectTasks: [TaskModel]?) {
        self.projectName = projectName
        self.projectKey = genereteKey()
        self.projectTasks = projectTasks
    }
}
