//
//  FeedbackModel.swift
//  Optimi
//
//  Created by Pedro Pessuto on 28/03/24.
//

import Foundation

struct FeedbackModel: Encodable, Decodable {
	 var id: Int? = nil
	 var CreatedAt: Date? = nil
	 var description: String
	 var feedbackStatus: String
	 //var tags: [String] = nil
	 //var feedbackDesigners: [String] = nil
}
