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
	var taskStatus: String? = "Ready for Dev"
	var taskDesigners: String? = ""
	var taskDevelopers: String? = ""
	
	func getRecord() -> CKRecord {
		let taskRecord = CKRecord(recordType: RecordNames.Task.rawValue)
		
		taskRecord.setValue(self.taskName, forKey: TaskFields.taskName.rawValue)
		
		return taskRecord
	}
	
	init?(_ record: CKRecord) {
		
		guard let taskName = record[TaskFields.taskName.rawValue] as? String,
				let taskDescription = record[TaskFields.taskDescription.rawValue] as? String,
				let taskLink = record[TaskFields.taskLink.rawValue] as? String,
				let taskPrototypeLink = record[TaskFields.taskPrototypeLink.rawValue] as? String,
				let taskStatus = record[TaskFields.taskStatus.rawValue] as? String,
				let taskDesigners = record[TaskFields.taskDesigners.rawValue] as? String,
				let taskDevelopers = record[TaskFields.taskDevelopers.rawValue] as? String
		else { return nil }
		self.taskId = record.recordID.recordName
		self.taskName = taskName
		self.taskCreatedAt = record.creationDate
		self.taskDescription = taskDescription
		self.taskLink = taskLink
		self.taskPrototypeLink = taskPrototypeLink
		self.taskProjectReference = record.parent?.recordID
		self.taskStatus = taskStatus
		self.taskDesigners = taskDesigners
		self.taskDevelopers = taskDevelopers
	}
	
	init(taskName: String, taskDescription: String?, taskLink: String?, taskPrototypeLink: String?, taskProjectReference: CKRecord.ID, taskStatus: String? = "Ready for Dev", taskDesigners: String? = "", taskDevelopers: String? = "") {
		self.taskName = taskName
		self.taskDescription = taskDescription
		self.taskLink = taskLink
		self.taskPrototypeLink = taskPrototypeLink
		self.taskProjectReference = taskProjectReference
		self.taskStatus = taskStatus
		self.taskDesigners = taskDesigners
		self.taskDevelopers = taskDevelopers
	}
}
