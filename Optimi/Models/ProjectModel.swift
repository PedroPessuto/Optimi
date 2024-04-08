//
//  ProjectModel.swift
//  Optimi
//
//  Created by Pedro Pessuto on 28/03/24.
//

import Foundation

struct ProjectModel: Encodable, Decodable {
	 var projectName: String
	 var projectCreatedAt: Date? = nil
	 var projectId: Int? = nil
	 var projectKey: String? = nil
	 
	 private func genereteKey() -> String {
		  var baseIntA = Int(arc4random() % 65535)
		  var baseIntB = Int(arc4random() % 65535)
		  var str = String(format: "%06X%06X", baseIntA, baseIntB)
		  baseIntA = Int(arc4random() % 65535)
		  baseIntB = Int(arc4random() % 65535)
		  str = str + "-" + String(format: "%06X%06X", baseIntA, baseIntB)
		  baseIntA = Int(arc4random() % 65535)
		  baseIntB = Int(arc4random() % 65535)
		  str = str + "-" + String(format: "%06X%06X", baseIntA, baseIntB)
		  baseIntA = Int(arc4random() % 65535)
		  baseIntB = Int(arc4random() % 65535)
		  str = str + "-" + String(format: "%06X%06X", baseIntA, baseIntB)
		  return str
	 }
	 
	 init(projectName: String) {
		  self.projectName = projectName
		  self.projectKey = genereteKey()
	 }
}

