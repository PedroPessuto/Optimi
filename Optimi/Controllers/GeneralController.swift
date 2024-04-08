//
//  GeneralController.swift
//  Optimi
//
//  Created by Pedro Pessuto on 28/03/24.
//

import Foundation

@Observable class GeneralController {
	
	public var viewController: ViewController = ViewController()
	public var supabaseController: SupabaseController = SupabaseController()
	
	var nome: String = ""
	var cargo: Cargo = .Designer
	
	var project: ProjectModel? = nil
	var projectKey: String = ""
	var tasks: [TaskModel] = []
	
	var currentScreen: String = "Home"
	
	func getInfo() async -> Void {
		do {
			let project = try await getProject()
			self.viewController.project = project
			
			let tasks = await getTasks()
			self.viewController.tasks = tasks
		}
		catch {
			print("Erro ao carregar informações")
		}
		
	}
	
	func getProject() async throws -> ProjectModel? {
		let response: [ProjectModel] = try await supabaseController.supabase.database
			.from("Project")
			.select()
			.eq("projectKey", value: "\(self.projectKey)")
			.execute()
			.value
		
		if response.isEmpty {
			return nil
		}
		
		let project = response.first
		
		return project
	}
	
	
	
	
	
	
	func getTasks(from taskIDs: [Int]) async throws -> [TaskModel] {
		var myProjectTasks: [TaskModel] = []
		
		for taskId in taskIDs {
			let tasksResponse: [TaskModel] = try await supabaseController.supabase.database
				.from("Task")
				.select()
				.eq("id", value: taskId)
				.execute()
				.value
			myProjectTasks.append(tasksResponse.first!)
		}
		
		return myProjectTasks
	}
	
	func updateTaskStatus(status: String, from taskID: Int) async throws {
		try await supabaseController.supabase.database
			.from("Task")
			.update(["status": "\(status)"])
			.eq("id", value: taskID)
			.execute()
	}
	
	func getDeliveries(from task: TaskModel) async throws -> [DeliveryModel] {
		var deliveriesIDs: [Int] = []
		
		let deliveriesIDsResponse: [TaskDeliveryModel] = try await supabaseController.supabase.database
			.from("Task-Delivery")
			.select()
			.eq("idTask", value: "\(task.id!)")
			.execute()
			.value
		
		for deliveryResponse in deliveriesIDsResponse {
			deliveriesIDs.append(deliveryResponse.idDelivery!)
		}
		
		
		var deliveries: [DeliveryModel] = []
		
		for id in deliveriesIDs {
			let deliveriesResponse: [DeliveryModel] = try await supabaseController.supabase.database
				.from("Delivery")
				.select()
				.eq("id", value: "\(id)")
				.execute()
				.value
			deliveries.append(deliveriesResponse.first!)
		}
		
		return deliveries
	}
	
	
	func getTasks() async -> [TaskModel] {
		do {
			print(self.viewController.project?.projectId ?? -999)
			
			let projectId = self.viewController.project?.projectId ?? 0
			
			let response: [TaskModel] = try await supabaseController.supabase.database
				.from("Task")
				.select("*, \"Project-Task\"!inner(*)")
				.eq("\"Project-Task\".idProject", value: projectId)
				.execute()
				.value
			
			return response
		} catch {
			print("Erro:", error)
			return []
		}
	}
	
	
	func getFeedback(from delivery: DeliveryModel) async throws -> FeedbackModel? {
		var idFeedback: Int = -1
		
		let feedbackIDResponse: [DeliveryFeedbackModel] = try await supabaseController.supabase.database
			.from("Delivery-Feedback")
			.select()
			.eq("idDelivery", value: delivery.id!)
			.execute()
			.value
		
		if feedbackIDResponse.isEmpty {
			return nil
		}
		
		idFeedback = (feedbackIDResponse.first?.idFeedback)!
		
		let feedbackResponse: [FeedbackModel] = try await supabaseController.supabase.database
			.from("Feedback")
			.select()
			.eq("id", value: idFeedback)
			.execute()
			.value
		
		return feedbackResponse.first
		
	}
	
	
}

enum Cargo {
	case Developer
	case Designer
	
	var title: String {
		switch self {
		case .Designer:
			return "Designer"
		case .Developer:
			return "Developer"
		}
	}
}
