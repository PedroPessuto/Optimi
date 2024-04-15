//
//  CloudController.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import Foundation
import CloudKit

@Observable class CloudController {
	let container: CKContainer
	let databasePublic: CKDatabase
	
	init() {
		container = CKContainer.default()
		databasePublic = container.publicCloudDatabase
	}
	
	// ========== PROJECT FUNCTIONS ==========
	
	// Cria um projeto
	public func createProject(_ projectName: String) async -> ProjectModel? {
		do {
			let project = ProjectModel(projectName: projectName)
			let projectRecord = project.getRecord()
			let record = try await databasePublic.save(projectRecord)
			let newProject = ProjectModel(record)
			return newProject
		}
		catch {
			return nil
		}
	}
	
	// Acessa um projeto
	public func getProject(_ projectKey: String) async -> ProjectModel? {
		let recordId = CKRecord.ID(recordName: projectKey)
		do {
			let record = try await self.databasePublic.record(for: recordId)
			return ProjectModel(record)
		}
		catch {
			return nil
		}
	}
	
	// ========== TASKS FUNCTIONS ==========
	
	public func createTask(_ taskModel: TaskModel) async -> TaskModel? {
		
		if (taskModel.taskProjectReference == nil) {
			return nil
		}
		
		do {
			let taskRecord = taskModel.getRecord()
			let reference = CKRecord.Reference(recordID: taskModel.taskProjectReference!, action: .deleteSelf)
			taskRecord.setValue(reference, forKey: TaskFields.taskProjectReference.rawValue)
			let record = try await databasePublic.save(taskRecord)
			let newTask = TaskModel(record)
			return newTask
		}
		catch {
			return nil
		}
	}
	
	
	public func getTasksFromProject(_ projectID: CKRecord.ID) async -> [TaskModel] {
		let recordToMatch = CKRecord.Reference(recordID: projectID, action: .deleteSelf)
		
		let predicate = NSPredicate(format: "\(TaskFields.taskProjectReference.rawValue) == %@", recordToMatch)
		
		let query = CKQuery(recordType: RecordNames.Task.rawValue, predicate: predicate)
		
		do {
			let result = try await CKContainer.default().publicCloudDatabase.records(matching: query)
			let records = result.matchResults.compactMap { try? $0.1.get() }
			print(records)
			return records.compactMap(TaskModel.init)
		} catch {
			print("Error fetching tasks from project: \(error)")
		}
		return []
	}
	// Cria um predicado que compara o ID do registro com o projectKey fornecido
	//            let predicate = NSPredicate(format: "recordID == %@", CKRecord.ID(recordName: projectKey))
	//            let query = CKQuery(recordType: RecordNames.Project.rawValue, predicate: predicate)
	//
	//            let result = try await databasePublic.records(matching: query)
	//            let records = result.matchResults.compactMap { try? $0.1.get() }
	//
	//            if let record = records.first {
	//                let newProject = ProjectModel(record)
	//                return newProject
	//            }
	
	public func createFeedback(_ feedback: FeedbackModel, _ delivery: DeliveryModel) async -> FeedbackModel? {
		do {
			let reference = CKRecord.Reference(recordID: CKRecord.ID(recordName: delivery.deliveryId!), action: .deleteSelf)
			let record = CKRecord(recordType: RecordNames.Feedback.rawValue)
			record.setValue(feedback.feedbackId, forKey: FeedbackFields.feedbackId.rawValue)
			record.setValue(feedback.feedbackStatus, forKey: FeedbackFields.feedbackStatus.rawValue)
			record.setValue(feedback.feedbackTags, forKey: FeedbackFields.feedbackTags.rawValue)
			record.setValue(feedback.feedbackDescription, forKey: FeedbackFields.feedbackDescription.rawValue)
			record.setValue(reference, forKey: FeedbackFields.feedbackDeliveryReference.rawValue)
			
			return FeedbackModel.init(try await databasePublic.save(record))
		} catch {
			print("Error saving feedback: \(error)")
			return nil
		}
	}
	
	public func deleteFeedback(_ feedback: FeedbackModel) async {
		do {
			let record = CKRecord(recordType: RecordNames.Feedback.rawValue)
			try await databasePublic.deleteRecord(withID: record.recordID)
		} catch {
			print("Error deleting feedback: \(error)")
		}
	}
	
	public func getFeedbacksFromDelivery(_ deliveryID: CKRecord.ID) async -> [FeedbackModel] {
		do {
			let recordToMatch = CKRecord.Reference(recordID: deliveryID, action: .deleteSelf)
			
			let predicate = NSPredicate(format: "\(FeedbackFields.feedbackDeliveryReference.rawValue) == %@", recordToMatch)
			
			let query = CKQuery(recordType: RecordNames.Feedback.rawValue, predicate: predicate)
			
			let result = try await databasePublic.records(matching: query)
			let records = result.matchResults.compactMap { try? $0.1.get() }
			return records.compactMap(FeedbackModel.init)
		} catch {
			print("Error fetching feedbacks from deliveries: \(error)")
			return []
		}
	}
	
	// ========== DELIVERY FUNCTIONS ==========
	// MARK: Create a Delivery on database
	public func createDelivery(deliveryModel: DeliveryModel, taskId: String) async -> DeliveryModel? {
		do {
			let deliveryRecord = deliveryModel.getRecord()
			let reference = CKRecord.Reference(recordID: CKRecord.ID(recordName: taskId), action: .deleteSelf)
			deliveryRecord.setValue(reference, forKey: DeliveryFields.deliveryTaskReference.rawValue)
			let record = try await databasePublic.save(deliveryRecord)
			let newDelivery = DeliveryModel(record)
			return newDelivery
		}
		catch {
			print("Error creating delivery: \(error)")
			return nil
		}
	}
	// MARK: Get Deliveries from task
	public func getDeliveriesFromTask(_ taskId: CKRecord.ID) async -> [DeliveryModel] {
		do {
			let recordToMatch = CKRecord.Reference(recordID: taskId, action: .deleteSelf)
			let predicate = NSPredicate(format: "\(DeliveryFields.deliveryTaskReference.rawValue) == %@", recordToMatch)
			let query = CKQuery(recordType: RecordNames.Delivery.rawValue, predicate: predicate)
			let result = try await databasePublic.records(matching: query)
			let records = result.matchResults.compactMap { try? $0.1.get() }
			return records.compactMap(DeliveryModel.init)
		}
		catch {
			return []
		}
	}
	// MARK: Delete a delivery from database
	public func deleteDelivery(_ deliveryModel: DeliveryModel) async -> Void {
		do {
			let deliveryRecord = deliveryModel.getRecord()
			try await self.databasePublic.deleteRecord(withID: deliveryRecord.recordID)
		}
		catch {
			return
		}
	}
}
