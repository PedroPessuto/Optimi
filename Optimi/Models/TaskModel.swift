//
//  TaskModel.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import Foundation
import CloudKit

class TaskModel {
    var taskId: String?
    var taskName: String
    var taskDescription: String?
    var taskCreatedAt: Date?
    var taskLink: String?
    var taskPrototypeLink: String?
    var taskProjectReference: CKRecord.ID?
    
    func getRecord() -> CKRecord {
        let taskRecord = CKRecord(recordType: RecordNames.Task.rawValue)
       
        taskRecord.setValue(self.taskName, forKey: TaskFields.taskName.rawValue)
        
        return taskRecord
    }
    
    init?(_ record: CKRecord) {
        
        guard let taskName = record[TaskFields.taskName.rawValue] as? String,
              let taskProjectReference = record[TaskFields.taskProjectReference.rawValue]
    else { return nil }
        self.taskId = record.recordID.recordName
        self.taskName = taskName
        self.taskCreatedAt = record.creationDate
//        self.taskDescription = record[TaskFields.taskDescription.rawValue] as? String
//        self.taskLink = record[TaskFields.taskLink.rawValue] as? String
//        self.taskPrototypeLink = record[TaskFields.taskPrototypeLink.rawValue] as? String
        self.taskProjectReference = record.parent?.recordID
    }
    
    init(taskName: String, taskDescription: String?, taskLink: String?, taskPrototypeLink: String?, taskProjectReference: CKRecord.ID) {
        self.taskName = taskName
        self.taskDescription = taskDescription
        self.taskLink = taskLink
        self.taskPrototypeLink = taskPrototypeLink
        self.taskProjectReference = taskProjectReference
    }
}
