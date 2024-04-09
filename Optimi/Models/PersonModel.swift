//
//  Person.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import Foundation
import CloudKit

class PersonModel {
    public var personId: String
    public var personName: String?
    public var personRecord: CKRecord

    init?(_ record: CKRecord) {
        guard let personName = record[PersonFields.personName.rawValue] as? String else {return nil}
        self.personId = record.recordID.recordName
        self.personName = personName
        self.personRecord = record
    }
    
    init(personName: String) {
        let personRecord = CKRecord(recordType: RecordNames.Person.rawValue)
        self.personId = personRecord.recordID.recordName
        self.personName = personName
        personRecord.setValue(self.personName, forKey: PersonFields.personName.rawValue)
        personRecord.setValue(self.personId, forKey: PersonFields.personId.rawValue)
        self.personRecord = personRecord
    }
}
