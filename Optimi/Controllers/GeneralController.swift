//
//  GeneralController.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import Foundation

@Observable class GeneralController {
    private var cloudController: CloudController = CloudController()
    public var screen: ScreenNames = .HomeView
    public var account: AccountModel?
    public var project: ProjectModel?
    
    // ========== PROJECT FUNCTIONS ==========
    
    // Cria um projeto
    public func createProject(_ projectName: String) async {
        let project = await self.cloudController.createProject(projectName)
        self.project = project
        self.screen = .ProjectView
    }
    
    // Acessa um projeto
    public func getProject(_ projetKey: String) async {
        let project = await self.cloudController.getProject(projetKey)
        self.project = project
        if (project != nil) {
            screen = ScreenNames.ProjectView
        }
        else {
            screen = ScreenNames.ProjectNotFoundView
        }
    }
    
    // ========== TASKS FUNCTIONS ==========
    
    public func createTask(taskName: String, taskDescription: String = "", taskLink: String = "", taskProtorypeLink: String = "") async {
        
        if let project = self.project {
            let taskModel = TaskModel(taskName: taskName, taskDescription: taskDescription, taskLink: taskLink, taskPrototypeLink: taskProtorypeLink, taskProjectReference: project.projectId!)
            let task = await self.cloudController.createTask(taskModel)
            if let t = task {
                self.project?.projectTasks.append(t)
            }
        }
        
    }
	
	public func getTasksFromProject() async {
		if let projectID = self.project?.projectId {
				self.project?.projectTasks = await self.cloudController.getTasksFromProject(projectID)
			}
		}

}
