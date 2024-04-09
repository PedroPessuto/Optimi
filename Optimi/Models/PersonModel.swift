//
//  Person.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import Foundation
import CloudKit

class PersonModel {
    public var personId: CKRecord.ID
    public var personName: String
    public var record: CKRecord

    init?(_ record: CKRecord) {
        guard let personName = record["personName"] as? String else {return nil}
        self.personId = record.recordID
        self.personName = personName
        self.record = record
    }
    
    init(personName: String) {
        let personRecord = CKRecord(recordType: RecordNames.Person.rawValue)
        self.personId = personRecord.recordID
        self.personName = personName
        self.record = personRecord
    }
}
