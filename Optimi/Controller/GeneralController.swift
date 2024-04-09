//
//  GeneralController.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import Foundation

@Observable class GeneralController {
    private var cloudController: CloudController = CloudController()
    
    public var project: ProjectModel?
    
    // ========== PROJECT FUNCTIONS ==========
    
    public func createProject(_ projectName: String) async {
        let project = await self.cloudController.createProject(projectName)
        self.project = project
    }
    
    public func getProject(_ projetKey: String) async {
        let project = await self.cloudController.getProject(projetKey)
        self.project = project
    }
    
}
