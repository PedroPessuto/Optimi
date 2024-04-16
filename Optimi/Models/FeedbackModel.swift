//
//  FeedbackModel.swift
//  Optimi
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 12/04/24.
//

import Foundation
import CloudKit

@Observable class FeedbackModel {
	public var feedbackId: String?
	public var feedbackStatus: String?
	public var feedbackTags: [String] = []
	public var feedbackDescription: [String] = []
	public var feedbackDeliveryReference: String?
	public var feedbackCreatedAt: Date?
	public var feedbackDesigner: String?
	
	init?(_ record: CKRecord) {
		guard
			let feedbackStatus = record[FeedbackFields.feedbackStatus.rawValue] as? String,
			let feedbackTags = record[FeedbackFields.feedbackTags.rawValue] as? [String],
			let feedbackDescription = record[FeedbackFields.feedbackDescription.rawValue] as? [String],
			let feedbackDesigner = record[FeedbackFields.feedbackDesigner.rawValue] as? String
		else { return nil }
		self.feedbackId = record.recordID.recordName
		self.feedbackStatus = feedbackStatus
		self.feedbackTags = feedbackTags
		self.feedbackDescription = feedbackDescription
		self.feedbackDeliveryReference = record.parent?.recordID.recordName
		self.feedbackCreatedAt = record.creationDate
		self.feedbackDesigner = feedbackDesigner
	}
	
	init(feedbackStatus: String, feedbackTags: [String], feedbackDescription: [String], feedbackDesigner: String) {
		self.feedbackId = nil
		self.feedbackStatus = feedbackStatus
		self.feedbackTags = feedbackTags
		self.feedbackDescription = feedbackDescription
		self.feedbackDeliveryReference = nil
		self.feedbackDesigner = feedbackDesigner
	}
}
