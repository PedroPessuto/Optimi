//
//  GeneralController.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import Foundation
import CloudKit

@Observable class GeneralController {
    private var cloudController: CloudController = CloudController()
    public var screen: ScreenNames = .HomeView
    public var account: AccountModel?
    public var project: ProjectModel?
    
    
    public func checkAccountStatus() async -> CKAccountStatus? {
        return await cloudController.checkAccountStatus() ?? nil
    }
    
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
    
    // MARK: Delete a project
    public func deleteProject() async -> Void {
        if self.project != nil {
            await cloudController.deleteProject(self.project!)
            self.screen = .HomeView
        }
        
    }
    

	
	// ========== TASKS FUNCTIONS ==========
	
	public func createTask(taskName: String, taskDescription: String = "", taskLink: String = "", taskPrototypeLink: String = "", taskDesigners: String = "", taskDeadline: Date?) async {
		
		if let project = self.project {
			let taskModel = TaskModel(taskName: taskName, 
											  taskDescription: taskDescription,
											  taskLink: taskLink,
											  taskPrototypeLink: taskPrototypeLink,
											  taskProjectReference: project.projectId!,
											  taskDesigners: self.account?.accountName ?? taskDesigners,
											  taskDevelopers: "Nenhum dev associado...",
											  taskDeadline: taskDeadline)
			let task = await self.cloudController.createTask(taskModel)
			if let t = task {
				self.project?.projectTasks.append(t)
			}
		}
		
	}
	
	public func getTasksFromProject() async {
		if let projectID = self.project?.projectId {
			let response = await self.cloudController.getTasksFromProject(projectID)
			self.project?.projectTasks = response
		}
	}

    
    public func changeTaskStatus(_ taskModel: TaskModel, _ taskStatus: TaskStatus) async {
        
        await self.cloudController.changeTaskStatus(taskModel, taskStatus: taskStatus, personName: account!.accountName, role: account!.accountRole)
    }
    
    // MARK: Delete a task from database
    public func deleteTask(taskModel: TaskModel) async -> Void {
        await cloudController.deleteTask(taskModel)
        self.project!.projectTasks.removeAll { task in
            task.taskId == taskModel.taskId
        }
    }
    
    
    // ========== FEEDBACK FUNCTIONS ==========
    
    public func createFeedback(_ feedback: FeedbackModel, _ delivery: DeliveryModel, _ task: TaskModel) async -> FeedbackModel? {
        let response = await cloudController.createFeedback(feedback, delivery)
        if let approved = response!.feedbackStatus {
            if approved == "Aprovada" {
                await cloudController.changeDeliveryStatus(delivery, deliveryStatus: .Approved)
                await cloudController.changeOnlyTaskStatus(task, taskStatus: .Aprovado)
                delivery.deliveryStatus = DeliveryStatus.Approved
                task.taskStatus = TaskStatus.Aprovado.rawValue
            }
            else {
                await cloudController.changeDeliveryStatus(delivery, deliveryStatus: .Reproved)
                await cloudController.changeOnlyTaskStatus(task, taskStatus: .Reprovada)
                delivery.deliveryStatus = DeliveryStatus.Reproved
                task.taskStatus = TaskStatus.ReadyForDev.rawValue
            }
        }
      
        return response
    }
    
    public func deleteFeedback(_ feedback: FeedbackModel) async {
        await cloudController.deleteFeedback(feedback)
    }
    
    public func getFeedbacksFromDelivery(_ delivery: DeliveryModel) async -> [FeedbackModel] {
        await cloudController.getFeedbacksFromDelivery(delivery.getRecord().recordID)
    }
    
    // MARK: Delete a feedback from database
    public func deleteFeedback(feedbackModel: FeedbackModel, deliveryModel: DeliveryModel) async -> Void {
        await cloudController.deleteFeedback(feedbackModel)
        deliveryModel.deliveryFeedbacks.removeAll { feedback in
            feedback.feedbackId == feedbackModel.feedbackId
        }
    }
    
    
    // ========== DELIVERY FUNCTIONS ==========
    
    public func createDelivery(_ deliveryModel: DeliveryModel, _ taskId: String) async -> DeliveryModel? {
        if self.project != nil {
            let newDelivery = await cloudController.createDelivery(deliveryModel: deliveryModel, taskId: taskId)
            if let delivery = newDelivery {
                for task in self.project!.projectTasks {
                    if (task.taskId == taskId) {
                        task.taskDeliveries.append(delivery)
                        task.taskStatus = TaskStatus.RevisaoPendente.rawValue
                        await cloudController.changeOnlyTaskStatus(task, taskStatus: .RevisaoPendente)
                        break
                    }
                }
            }
            
            return newDelivery
        }
        return nil
    }
    
    public func deleteDelivery(_ deliveryModel: DeliveryModel, _ taskId: String) async -> Void {
        await cloudController.deleteDelivery(deliveryModel)
        if (self.project != nil) {
            for task in self.project!.projectTasks {
                if (task.taskId == taskId) {
                    task.taskDeliveries.removeAll { delivery in
                        deliveryModel.deliveryId == delivery.deliveryId
                    }
                }
            }
        }
    }
    
    public func getDeliveriesFromTask(_ task: TaskModel) async -> Void {
        if (self.project?.projectId) != nil {
            let record = task.getRecord()
            let response = await self.cloudController.getDeliveriesFromTask(record.recordID)
            task.taskDeliveries = response
        }
    }
    
    // MARK: Delete a delivery from database
    public func deleteDelivery(_ deliveryModel: DeliveryModel, _ taskModel: TaskModel) async -> Void {
        await cloudController.deleteDelivery(deliveryModel)
        taskModel.taskDeliveries.removeAll { delivery in
            delivery.deliveryId == deliveryModel.deliveryId
        }
    }
    
    
   
    
}

// Delivery criada --> delivery pendente --> task: revisao pendente
// Feedback Aprovado --> delivery aprovada --> task aprovada
// Feedback reprovar --> delivery reprovada --> task ready for dev
