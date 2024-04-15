//
//  FeedbackModel.swift
//  Optimi
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 12/04/24.
//

import Foundation
import CloudKit

@Observable class FeedbackModel {
	public var feedbackId: String
	public var feedbackStatus: String?
	public var feedbackTags: [String] = []
	public var feedbackDescription: [String] = []
	
	init?(_ record: CKRecord) {
		guard
			let feedbackStatus = record[FeedbackFields.feedbackStatus.rawValue] as? String,
			let feedbackTags = record[FeedbackFields.feedbackTags.rawValue] as? [String],
			let feedbackDescription = record[FeedbackFields.feedbackDescription.rawValue] as? [String]
		else { return nil }
		self.feedbackId = record.recordID.recordName
		self.feedbackStatus = feedbackStatus
		self.feedbackTags = feedbackTags
		self.feedbackDescription = feedbackDescription
	}
	
	init(feedbackStatus: String, feedbackTags: [String], feedbackDescription: [String]) {
		let feedbackRecord = CKRecord(recordType: RecordNames.Feedback.rawValue)
		self.feedbackId = feedbackRecord.recordID.recordName
		self.feedbackStatus = feedbackStatus
		self.feedbackTags = feedbackTags
		self.feedbackDescription = feedbackDescription
		feedbackRecord.setValue(self.feedbackStatus, forKey: FeedbackFields.feedbackStatus.rawValue)
		feedbackRecord.setValue(self.feedbackTags, forKey: FeedbackFields.feedbackTags.rawValue)
		feedbackRecord.setValue(self.feedbackDescription, forKey: FeedbackFields.feedbackDescription.rawValue)
	}
}
