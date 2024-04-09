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
    
    public func createProject(_ projectName: String) async -> ProjectModel? {
        do {
            let project = ProjectModel(projectName: projectName)
            let record = try await databasePublic.save(project.record)
            let newProject = ProjectModel(record)
            return newProject
        }
        catch {
            print("Erro ao criar projeto")
            return nil
        }
    }
    
    public func getProject(_ projectKey: String) async -> ProjectModel? {
        do {
            // Cria um predicado que compara o ID do registro com o projectKey fornecido
            let predicate = NSPredicate(format: "recordID == %@", CKRecord.ID(recordName: projectKey))
            let query = CKQuery(recordType: RecordNames.Project.rawValue, predicate: predicate)

            let result = try await databasePublic.records(matching: query)
            let records = result.matchResults.compactMap { try? $0.1.get() }

            if let record = records.first {
                let newProject = ProjectModel(record)
                return newProject
            }
            return nil
        }
        catch {
            print("Erro ao buscar projeto: \(error)")
            return nil
        }
    }

    
    // ========== TASKS FUNCTIONS ==========
    
    
    
    
    
}
