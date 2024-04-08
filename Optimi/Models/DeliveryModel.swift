//
//  DeliveryModel.swift
//  Optimi
//
//  Created by Pedro Pessuto on 28/03/24.
//

import Foundation

struct DeliveryModel: Encodable, Decodable, Hashable {
	 var id: Int? = nil
	 var created_At: Date? = nil
	 var name: String
	 var documentation: String
	 var implementationLink: String
	 var status: String
	 var developer: String? = nil
}
