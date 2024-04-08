//
//  TaskModel.swift
//  Optimi
//
//  Created by Pedro Pessuto on 28/03/24.
//

import Foundation

struct TaskModel: Encodable, Decodable, Hashable {
	 var id: Int? = nil
	 var createdAt: Date? = nil
	 var description: String? = nil
	 var prototypeLink: String? = nil
	 var taskLink: String? = nil
	 var status: String? = nil
	 var taskName: String? = nil
	var designers: [String]? = nil
}
