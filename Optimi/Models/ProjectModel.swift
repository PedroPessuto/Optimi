//
//  ProjectModel.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import Foundation
import CloudKit

class ProjectModel {
    public var projectId: CKRecord.ID
    public var projectName: String = ""
    public var record: CKRecord
    
    init?(_ record: CKRecord) {
        guard let projectName = record["projectName"] as? String else {return nil}
        self.projectId = record.recordID
        self.projectName = projectName
        self.record = record
    }
    
    init(projectName: String) {
        let projectRecord = CKRecord(recordType: RecordNames.Project.rawValue)
        self.projectId = projectRecord.recordID
        self.projectName = projectName
        self.record = projectRecord
    }
}
