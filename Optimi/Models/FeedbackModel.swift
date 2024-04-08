//
//  FeedbackModel.swift
//  Optimi
//
//  Created by Pedro Pessuto on 08/04/24.
//

import Foundation
import SwiftData

@Model
class FeedbackModel: Hashable {
    var feedbackId: String = "\(UUID())"
    var feedbackCreatedAt: Date = Date()
    var feedbackDescription: String = ""
    
    init(feedbackId: String = "", feedbackCreatedAt: Date = Date(), feedbackDescription: String) {
        self.feedbackId = feedbackId
        self.feedbackCreatedAt = feedbackCreatedAt
        self.feedbackDescription = feedbackDescription
    }
}
