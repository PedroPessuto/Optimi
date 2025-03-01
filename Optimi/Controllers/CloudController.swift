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
    
  	public func checkAccountStatus() async -> CKAccountStatus? {
		do {
			let result = try await CKContainer.default().accountStatus()
			switch result.rawValue {
			case 1:
				print("iCloud available")
			case 0:
				print("iCloud couldNotDetermine")
			case 2:
				print("iCloud restricted")
			case 3:
				print("iCloud noAccount")
			case 4:
				print("iCloud temprarilyUnavailable")
			default:
				break
			}
			return result
		} catch {
			print("Error checking account status: \(error)")
			return nil
		}
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
			  print("Error creating project: \(error)")
            return nil
        }
    }
    
    // Acessa um projeto
    public func getProject(_ projectKey: String) async -> ProjectModel? {
        if projectKey.count != 36 {
            return nil
        }
        let recordId = CKRecord.ID(recordName: projectKey)
        do {
            let record = try await self.databasePublic.record(for: recordId)
            return ProjectModel(record)
        }
        catch {
            return nil
        }
    }
    
    // MARK: Delete a project from database
    public func deleteProject(_ projectModel: ProjectModel) async -> Void {
        do {
            let record = projectModel.getRecord()
            try await self.databasePublic.deleteRecord(withID: record.recordID)
        }
        catch {
            return
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
            print("Error creating task: \(error)")
            return nil
        }
    }
    
    
    public func getTasksFromProject(_ projectID: CKRecord.ID) async -> [TaskModel] {
        let recordToMatch = CKRecord.Reference(recordID: projectID, action: .deleteSelf)
        
        let predicate = NSPredicate(format: "\(TaskFields.taskProjectReference.rawValue) == %@", recordToMatch)
        
        let query = CKQuery(recordType: RecordNames.Task.rawValue, predicate: predicate)
        
        do {
            let result = try await databasePublic.records(matching: query)
            let records = result.matchResults.compactMap { try? $0.1.get() }
            return records.compactMap(TaskModel.init)
        } catch {
            print("Error fetching tasks from project: \(error)")
        }
        return []
    }
    
    
    // MARK: Change Task Status From Database
    public func changeDeliveryStatus(_ delivery: DeliveryModel, deliveryStatus: DeliveryStatus) async {
        
        do {
            let rec = try await databasePublic.record(for: delivery.getRecord().recordID)
            rec.setValue(deliveryStatus.rawValue, forKey: "deliveryStatus")
            let saved = try await databasePublic.save(rec)
            delivery.update(saved)
            
        } catch {
            return
        }
    }
    
    
    // MARK: Change Task Status From Database
    public func changeOnlyTaskStatus(_ taskModel: TaskModel, taskStatus: TaskStatus) async {
        
        do {
            let rec = try await databasePublic.record(for: taskModel.getRecord().recordID)
            rec.setValue(taskStatus.rawValue, forKey: "taskStatus")
            let saved = try await databasePublic.save(rec)
            taskModel.update(record: saved)
        } catch {
            return
        }
    }
    
    // MARK: Change Task Status From Database
	public func changeTaskStatus(_ taskModel: TaskModel, taskStatus: TaskStatus, personName: String, role: Roles) async {
		
		do {
			let rec = try await databasePublic.record(for: taskModel.getRecord().recordID)
			rec.setValue(taskStatus.rawValue, forKey: "taskStatus")
			rec.setValue(personName, forKey: TaskFields.taskDevelopers.rawValue)
			let saved = try await databasePublic.save(rec)
			taskModel.update(record: saved)
			//taskModel.taskDevelopers?.append(personName)
		} catch {
			return
		}
	}
    
    // MARK: Delete a task from database
    public func deleteTask(_ taskModel: TaskModel) async -> Void {
        do {
            let taskRecord = taskModel.getRecord()
            try await self.databasePublic.deleteRecord(withID: taskRecord.recordID)
        }
        catch {
            return
        }
    }
    
    // MARK: Change Task Status From Database
    public func updateTask(_ task: TaskModel) async {
        
        do {
            let rec = try await databasePublic.record(for: task.getRecord().recordID)
            rec.setValue(task.taskName, forKey: TaskFields.taskName.rawValue)
            rec.setValue(task.taskDescription, forKey: TaskFields.taskDescription.rawValue)
            rec.setValue(task.taskLink, forKey: TaskFields.taskLink.rawValue)
            rec.setValue(task.taskPrototypeLink, forKey: TaskFields.taskPrototypeLink.rawValue)
            rec.setValue(task.taskDeadline, forKey: TaskFields.taskDeadline.rawValue)
            let saved = try await databasePublic.save(rec)
            task.update(record: saved)
            
        } catch {
            return
        }
    }
    
    // ========== FEEDBACK FUNCTIONS ==========
    
	public func createFeedback(_ feedback: FeedbackModel, _ delivery: DeliveryModel) async -> FeedbackModel? {
		do {
			let reference = CKRecord.Reference(recordID: CKRecord.ID(recordName: delivery.deliveryId!), action: .deleteSelf)
			let record = CKRecord(recordType: RecordNames.Feedback.rawValue)
			record.setValue(feedback.feedbackId, forKey: FeedbackFields.feedbackId.rawValue)
			record.setValue(feedback.feedbackStatus, forKey: FeedbackFields.feedbackStatus.rawValue)
			record.setValue(feedback.feedbackTags, forKey: FeedbackFields.feedbackTags.rawValue)
			record.setValue(feedback.feedbackDescription, forKey: FeedbackFields.feedbackDescription.rawValue)
			record.setValue(reference, forKey: FeedbackFields.feedbackDeliveryReference.rawValue)
			record.setValue(feedback.feedbackDesigner, forKey: FeedbackFields.feedbackDesigner.rawValue)
			
			return FeedbackModel.init(try await databasePublic.save(record))
		} catch {
			print("Error saving feedback: \(error)")
			return nil
		}
	}

  	public func deleteFeedback(_ feedback: FeedbackModel) async {
		do {
			let record = CKRecord(recordType: RecordNames.Feedback.rawValue, recordID: CKRecord.ID(recordName: feedback.feedbackId ?? ""))
			try await databasePublic.deleteRecord(withID: record.recordID)
		} catch {
			print("Error deleting feedback: \(error)")
		}
	}
    
    // MARK: Get Feedbacks from database
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
    
    // MARK: Change Task Status From Database
    public func changeFeedbackStatus(_ feedback: FeedbackModel, feedbackStatus: String) async {
        
        do {
            let rec = try await databasePublic.record(for: feedback.record!.recordID)
            rec.setValue(feedbackStatus, forKey: "taskStatus")
            let saved = try await databasePublic.save(rec)
            feedback.update(saved)
        } catch {
            return
        }
    }
    
    // MARK: Change Task Status From Database
    public func updateFeedback(_ feedback: FeedbackModel) async {
        
        do {
            
//            let rec = try await databasePublic.record(for: feedback.record.recordID)
            feedback.record!.setValue(feedback.feedbackDesigner, forKey: FeedbackFields.feedbackDesigner.rawValue)
            feedback.record!.setValue(feedback.feedbackTags, forKey: FeedbackFields.feedbackTags.rawValue)
            feedback.record!.setValue(feedback.feedbackDescription ,forKey: FeedbackFields.feedbackDescription.rawValue)
            feedback.record!.setValue(feedback.feedbackStatus ,forKey: FeedbackFields.feedbackStatus.rawValue)
            try await databasePublic.save( feedback.record!)
//            feedback.update(saved)
            
        }
        catch {
            print("2")
            return
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
    
    // MARK: Change Task Status From Database
    public func updateDelivery(_ delivery: DeliveryModel) async {
        
        do {
            let rec = try await databasePublic.record(for: delivery.getRecord().recordID)
            rec.setValue(delivery.deliveryName, forKey: DeliveryFields.deliveryName.rawValue)
            rec.setValue(delivery.deliveryDocumentation, forKey: DeliveryFields.deliveryDocumentation.rawValue)
            rec.setValue(delivery.deliveryImplementationLink, forKey: DeliveryFields.deliveryImplementationLink.rawValue)
            rec.setValue(delivery.deliveryDevelopers, forKey: DeliveryFields.deliveryDevelopers.rawValue)
            let saved = try await databasePublic.save(rec)
            delivery.update(saved)
            
        } 
        catch {
            return
        }
    }
    
    
   
}
