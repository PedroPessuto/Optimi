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
	
	init?(_ record: CKRecord) {
		guard
			let feedbackStatus = record[FeedbackFields.feedbackStatus.rawValue] as? String,
			let feedbackTags = record[FeedbackFields.feedbackTags.rawValue] as? [String],
			let feedbackDescription = record[FeedbackFields.feedbackDescription.rawValue] as? [String],
			let feedbackDeliveryReference = record[FeedbackFields.feedbackDeliveryReference.rawValue] as? String
		else { return nil }
		self.feedbackId = record.recordID.recordName
		self.feedbackStatus = feedbackStatus
		self.feedbackTags = feedbackTags
		self.feedbackDescription = feedbackDescription
		self.feedbackDeliveryReference = feedbackDeliveryReference
	}
	
	init(feedbackStatus: String, feedbackTags: [String], feedbackDescription: [String]) {
		self.feedbackId = nil
		self.feedbackStatus = feedbackStatus
		self.feedbackTags = feedbackTags
		self.feedbackDescription = feedbackDescription
	}
}
