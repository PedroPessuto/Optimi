//
// TaskModel.swift
// Optimi
//
// Created by Pedro Pessuto on 09/04/24.
//
import Foundation
import CloudKit
@Observable class TaskModel {
	var taskId: String?
	var taskName: String
	var taskDescription: String?
	var taskCreatedAt: Date?
	var taskLink: String?
	var taskPrototypeLink: String?
	var taskProjectReference: CKRecord.ID?
	var taskStatus: String? = "Ready for Dev"
	var taskDesigners: String?
	var taskDevelopers: String?
	var taskDeliveries: [DeliveryModel] = []
	
	func getRecord() -> CKRecord {
		var taskRecord = CKRecord(recordType: RecordNames.Task.rawValue)
		if let id = taskId {
			taskRecord = CKRecord(recordType: RecordNames.Task.rawValue, recordID: CKRecord.ID(recordName: taskId!))
		}
		taskRecord.setValue(self.taskId, forKey: TaskFields.taskId.rawValue)
		taskRecord.setValue(self.taskName, forKey: TaskFields.taskName.rawValue)
		taskRecord.setValue(self.taskDescription, forKey: TaskFields.taskDescription.rawValue)
		taskRecord.setValue(self.taskCreatedAt, forKey: TaskFields.taskCreatedAt.rawValue)
		taskRecord.setValue(self.taskLink, forKey: TaskFields.taskLink.rawValue)
		taskRecord.setValue(self.taskPrototypeLink, forKey: TaskFields.taskPrototypeLink.rawValue)
		taskRecord.setValue(self.taskProjectReference?.recordName, forKey: TaskFields.taskProjectReference.rawValue)
		taskRecord.setValue(self.taskStatus, forKey: TaskFields.taskStatus.rawValue)
		taskRecord.setValue(self.taskDesigners, forKey: TaskFields.taskDesigners.rawValue)
		taskRecord.setValue(self.taskDevelopers, forKey: TaskFields.taskDevelopers.rawValue)
		
		return taskRecord
	}
	
	init?(_ record: CKRecord) {
		guard let taskName = record[TaskFields.taskName.rawValue] as? String
		else { return nil }
		self.taskId = record.recordID.recordName
		self.taskName = taskName
		self.taskCreatedAt = record.creationDate
		self.taskDescription = record[TaskFields.taskDescription.rawValue] as? String
		self.taskLink = record[TaskFields.taskLink.rawValue] as? String
		self.taskPrototypeLink = record[TaskFields.taskPrototypeLink.rawValue] as? String
		self.taskProjectReference = record.parent?.recordID
		self.taskStatus = record[TaskFields.taskStatus.rawValue] as? String
		self.taskDesigners = record[TaskFields.taskDesigners.rawValue] as? String
		self.taskDevelopers = record[TaskFields.taskDevelopers.rawValue] as? String
	}
	
	init(taskName: String, taskDescription: String?, taskLink: String?, taskPrototypeLink: String?, taskProjectReference: CKRecord.ID, taskDesigners: String?) {
		self.taskName = taskName
		self.taskDescription = taskDescription
		self.taskLink = taskLink
		self.taskPrototypeLink = taskPrototypeLink
		self.taskProjectReference = taskProjectReference
		self.taskDesigners = taskDesigners
	}
}
