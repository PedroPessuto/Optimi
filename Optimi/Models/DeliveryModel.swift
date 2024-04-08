//
//  DeliveryModel.swift
//  Optimi
//
//  Created by Pedro Pessuto on 08/04/24.
//

import Foundation
import SwiftData

@Model
class DeliveryModel: Hashable {
    var deliveryId: String = "\(UUID())"
    var deliveryCreatedAt: Date = Date()
    var deliveryName: String = ""
    var deliveryDocumentation: String = ""
    var deliveryImplementationLink: String = ""
    var deliveryStatus: String = ""
    
    @Relationship(deleteRule: .noAction) var deliveryDevelopers: [PersonModel]? = nil
    @Relationship(deleteRule: .cascade) var deliveryFeedbacks: [FeedbackModel]? = nil
    
    init(deliveryName: String, deliveryDocumentation: String, deliveryImplementationLink: String, deliveryStatus: String, deliveryDevelopers: [PersonModel]? = nil) {
        self.deliveryName = deliveryName
        self.deliveryDocumentation = deliveryDocumentation
        self.deliveryImplementationLink = deliveryImplementationLink
        self.deliveryStatus = deliveryStatus
        self.deliveryDevelopers = deliveryDevelopers
    }
}
