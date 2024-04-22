//
//  ProjectModel.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import Foundation
import CloudKit

@Observable class ProjectModel {
    public var projectId: CKRecord.ID?
    public var projectName: String
    public var projectCreatedAt: Date?
    public var projectTasks: [TaskModel] = []
    
    func getRecord() -> CKRecord {
        let projectRecord = CKRecord(recordType: RecordNames.Project.rawValue, recordID: projectId ?? CKRecord(recordType: RecordNames.Project.rawValue, recordID: CKRecord.ID(recordName: UUID().uuidString)).recordID)
            
        projectRecord.setValue(self.projectName, forKey: ProjectFields.projectName.rawValue)
        
        if let createdAt = projectCreatedAt {
            projectRecord.setValue(createdAt, forKey: ProjectFields.projectCreatedAt.rawValue)
        }
        
        return projectRecord
    }
   
    init?(_ record: CKRecord) {
        guard let projectName = record[ProjectFields.projectName.rawValue] as? String else {return nil}
        self.projectName = projectName
        self.projectId = record.recordID
        self.projectCreatedAt = record.creationDate
    }
    
    init(projectName: String) {
        self.projectName = projectName
    }
}
