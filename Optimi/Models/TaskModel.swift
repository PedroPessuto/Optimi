//
//  TaskModel.swift
//  Optimi
//
//  Created by Pedro Pessuto on 08/04/24.
//

import Foundation
import SwiftData

@Model
class TaskModel: Hashable {
    var taskId: String = "\(UUID())"
    var taskCreatedAt: Date = Date()
    var taskDescription: String = ""
    var taskPrototypeLink: String = ""
    var taskLink: String = ""
    var taskStatus: String = ""
    var taskName: String = ""
    
    @Relationship(deleteRule: .noAction) var taskDesigners: [PersonModel]? = nil
    @Relationship(deleteRule: .cascade) var taskDeliveries: [DeliveryModel]? = nil
 
    init(taskDescription: String = "", taskPrototypeLink: String = "", taskLink: String = "", taskStatus: String = "", taskName: String = "", taskDesigners: [PersonModel]? = nil, taskDeliveries: [DeliveryModel]? = nil) {
        self.taskDescription = taskDescription
        self.taskPrototypeLink = taskPrototypeLink
        self.taskLink = taskLink
        self.taskStatus = taskStatus
        self.taskName = taskName
        self.taskDesigners = taskDesigners
        self.taskDeliveries = taskDeliveries
    }
}
