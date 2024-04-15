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
	
	public func createTask(taskName: String, taskDescription: String = "", taskLink: String = "", taskPrototypeLink: String = "", taskDesigners: String = "") async {
		
		if let project = self.project {
			let taskModel = TaskModel(taskName: taskName, taskDescription: taskDescription, taskLink: taskLink, taskPrototypeLink: taskPrototypeLink, taskProjectReference: project.projectId!, taskDesigners: taskDesigners)
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
	
	public func createFeedback(_ feedback: FeedbackModel, _ delivery: DeliveryModel) async {
		let response = await cloudController.createFeedback(feedback, delivery)
	}
	
	public func deleteFeedback(_ feedback: FeedbackModel) async {
		await cloudController.deleteFeedback(feedback)
	}
	
	public func getFeedbacks() async -> [FeedbackModel] {
		return []
	}
	
	// ========== DELIVERY FUNCTIONS ==========
	public func createDelivery(_ deliveryModel: DeliveryModel, _ taskId: String) async -> DeliveryModel? {
		if let project = self.project {
			let newDelivery = await cloudController.createDelivery(deliveryModel: deliveryModel, taskId: taskId)
			print(newDelivery)
			if let delivery = newDelivery {
				for task in self.project!.projectTasks {
					if (task.taskId == taskId) {
						task.taskDeliveries.append(delivery)
						print(task.taskDeliveries)
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
			print(response)
			task.taskDeliveries = response
		}
	}
}
