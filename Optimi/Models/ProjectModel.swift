//
//  ProjectModel.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import Foundation
import CloudKit

class ProjectModel {
    public var projectId: String
    public var projectName: String?
    public var projectCreatedAt: Date?
    public var projectRecord: CKRecord
    
    init?(_ record: CKRecord) {
        guard let projectName = record[ProjectFields.projectName.rawValue] as? String else {return nil}
        self.projectName = projectName
        self.projectId = record.recordID.recordName
        self.projectCreatedAt = record.creationDate
        self.projectRecord = record
    }
    
    init(projectName: String) {
        let projectRecord = CKRecord(recordType: RecordNames.Project.rawValue)
        self.projectId = projectRecord.recordID.recordName
        self.projectCreatedAt = Date()
        self.projectName = projectName
        projectRecord.setValue(self.projectId, forKey: ProjectFields.projectId.rawValue)
        projectRecord.setValue(self.projectName, forKey: ProjectFields.projectName.rawValue)
        projectRecord.setValue(self.projectCreatedAt, forKey: ProjectFields.projectCreatedAt.rawValue)
        self.projectRecord = projectRecord
    }
}
