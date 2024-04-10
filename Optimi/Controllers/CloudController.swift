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
    
    
    
}
