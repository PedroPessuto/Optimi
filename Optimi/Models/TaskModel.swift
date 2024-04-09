//
//  TaskModel.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import Foundation
import CloudKit


class TaskModel {
    var taskId: String
    var taskName: String?
    var taskDescription: String?
    var taskCreatedAt: Date?
    var taskLink: String?
    var taskPrototypeLink: String?
    var taskProjectReference: CKRecord.Reference
    var taskRecord: CKRecord
    
    init?(_ record: CKRecord) {
        guard let taskName = record[TaskFields.taskName.rawValue] as? String,
              let taskDescription = record[TaskFields.taskDescription.rawValue] as? String,
              let taskLink = record[TaskFields.taskLink.rawValue] as? String,
              let taskPrototypeLink = record[TaskFields.taskPrototypeLink.rawValue] as? String,
        let taskProjectReference = record[TaskFields.taskProjectReference.rawValue] as? CKRecord.Reference else { return nil }
        self.taskId = record.recordID.recordName
        self.taskName = taskName
        self.taskCreatedAt = record.creationDate
        self.taskDescription = taskDescription
        self.taskLink = taskLink
        self.taskPrototypeLink = taskPrototypeLink
        self.taskProjectReference = taskProjectReference
        self.taskRecord = record
    }
    
    init(taskName: String, taskDescription: String, taskLink: String, taskPrototypeLink: String, projectReference: CKRecord.Reference) {
        let taskRecord = CKRecord(recordType: RecordNames.Task.rawValue)
        self.taskId = taskRecord.recordID.recordName
        self.taskCreatedAt = Date()
        self.taskName = taskName
        self.taskDescription = taskDescription
        self.taskLink = taskLink
        self.taskPrototypeLink = taskPrototypeLink
        self.taskProjectReference = projectReference
        taskRecord.setValue(self.taskId, forKey: TaskFields.taskId.rawValue)
        taskRecord.setValue(self.taskName, forKey: TaskFields.taskName.rawValue)
        taskRecord.setValue(self.taskCreatedAt, forKey: TaskFields.taskCreatedAt.rawValue)
        taskRecord.setValue(self.taskDescription, forKey: TaskFields.taskDescription.rawValue)
        taskRecord.setValue(self.taskLink, forKey: TaskFields.taskLink.rawValue)
        taskRecord.setValue(self.taskPrototypeLink, forKey: TaskFields.taskPrototypeLink.rawValue)
        taskRecord.setValue(self.taskProjectReference, forKey: TaskFields.taskProjectReference.rawValue)
        self.taskRecord = taskRecord
    }
}
