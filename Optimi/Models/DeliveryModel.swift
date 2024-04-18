//
//  DeliveryModel.swift
//  Optimi
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 12/04/24.
//

import Foundation
import CloudKit

@Observable class DeliveryModel {
	// ========== ATTRIBUTES ==========
	// MARK: Optionals atributtes
	public var deliveryCreatedAt: Date?
	public var deliveryDevelopers: String?
	public var deliveryDocumentation: String?
	public var deliveryId: String?
	public var deliveryImplementationLink: String?
	public var deliveryTaskReference: String?
	// MARK: Requireds atributtes
	public var deliveryName: String
	public var deliveryStatus: DeliveryStatus = .ReadyForDev
    public var deliveryFeedbacks: [FeedbackModel] = []
    
	// ========== FUNCTIONS ==========
	// MARK: Creating a record to deliveryModel
	func getRecord() -> CKRecord {
		var deliveryRecord: CKRecord?
		if let id = deliveryId {
			deliveryRecord = CKRecord(recordType: RecordNames.Delivery.rawValue, recordID: CKRecord.ID(recordName: id))
		}
		else {
			deliveryRecord = CKRecord(recordType: RecordNames.Delivery.rawValue)
		}
		deliveryRecord!.setValue(deliveryName, forKey: DeliveryFields.deliveryName.rawValue)
		deliveryRecord!.setValue(deliveryDevelopers, forKey: DeliveryFields.deliveryDevelopers.rawValue)
		deliveryRecord!.setValue(deliveryDocumentation, forKey: DeliveryFields.deliveryDocumentation.rawValue)
		deliveryRecord!.setValue(deliveryImplementationLink, forKey: DeliveryFields.deliveryImplementationLink.rawValue)
		deliveryRecord!.setValue(deliveryStatus.rawValue, forKey: DeliveryFields.deliveryStatus.rawValue)
		return deliveryRecord!
	}
    
    
    func update(_ record: CKRecord) {
        
        guard
            let deliveryStatus = record[DeliveryFields.deliveryStatus.rawValue] as? String,
            let deliveryName = record[DeliveryFields.deliveryName.rawValue] as? String
        else { return  }
        self.deliveryId = record.recordID.recordName
        self.deliveryDevelopers = record[DeliveryFields.deliveryDevelopers.rawValue] as? String
        self.deliveryDocumentation = record[DeliveryFields.deliveryDocumentation.rawValue] as? String
        self.deliveryImplementationLink = record[DeliveryFields.deliveryImplementationLink.rawValue] as? String
        self.deliveryCreatedAt = record.creationDate
        self.deliveryName = deliveryName
        self.deliveryStatus = DeliveryStatus.init(rawValue: deliveryStatus)!
        self.deliveryTaskReference = record.parent?.recordID.recordName
    
    }
	// ========== BUILDERS ==========
	// MARK: Init from cloud record
	init?(_ record: CKRecord) {
		guard
			let deliveryStatus = record[DeliveryFields.deliveryStatus.rawValue] as? String,
			let deliveryName = record[DeliveryFields.deliveryName.rawValue] as? String
		else { return nil }
		self.deliveryId = record.recordID.recordName
		self.deliveryDevelopers = record[DeliveryFields.deliveryDevelopers.rawValue] as? String
		self.deliveryDocumentation = record[DeliveryFields.deliveryDocumentation.rawValue] as? String
		self.deliveryImplementationLink = record[DeliveryFields.deliveryImplementationLink.rawValue] as? String
		self.deliveryCreatedAt = record.creationDate
		self.deliveryName = deliveryName
		self.deliveryStatus = DeliveryStatus.init(rawValue: deliveryStatus)!
		self.deliveryTaskReference = record.parent?.recordID.recordName
	}
	// MARK: Init for first create
	init(deliveryName: String, deliveryDevelopers: String = "", deliveryDocumentation: String? = nil, deliveryImplementationLink: String? = nil) {
		self.deliveryName = deliveryName
		self.deliveryDevelopers = deliveryDevelopers
		self.deliveryDocumentation = deliveryDocumentation
		self.deliveryImplementationLink = deliveryImplementationLink
	}
}
