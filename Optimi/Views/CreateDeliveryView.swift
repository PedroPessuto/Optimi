//
//  CreateDeliveryView.swift
//  Optimi
//
//  Created by Marina Martin on 04/04/24.
//

import SwiftUI

struct CreateDeliveryView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(GeneralController.self) var controller
	
	var task: TaskModel
	
	@State public var deliveryName: String = ""
	@State public var deliveryDescription: String = ""
	@State public var implementationLink: String = ""
	
	var body: some View {
		NavigationStack{
			VStack(alignment: .leading){
				
				cardTitle
				
				description
				
				Text("Nome da Entrega")
					.font(.headline)
				
				TextField("Entrega", text: $deliveryName)
				
				Text("Descrição da Entrega")
					.font(.headline)
				
				TextField("Descrição", text: $deliveryDescription)
				
				Text("Link do vídeo/foto")
					.font(.headline)
				
				TextField("link", text: $implementationLink)
				
				
				HStack{
					Spacer()
					
					Button(action: {
						dismiss()
					}, label: {
						ZStack{
							Text("Cancelar")
						}
					})
					
					Button(action: {
						
						var delivery: DeliveryModel? = DeliveryModel(name: deliveryName, documentation: deliveryDescription, implementationLink: implementationLink, status: "Ready for Designer")
						
						Task {
							delivery = await controller.supabaseController.insertOneAndReturn(tableName: "Delivery", object: delivery)!
							
							var delivery_task: TaskDeliveryModel? = nil
							
							if let y = delivery {
								delivery_task = TaskDeliveryModel(idTask: controller.viewController.task?.id, idDelivery: y.id)
								
								if let x = delivery_task {
									delivery_task = await controller.supabaseController.insertOneAndReturn(tableName: "Task-Delivery", object: x)
								}
							}
						}
						
						Task{
							try await controller.updateTaskStatus(status: "Ready for Designer", from: task.id ?? 0)
							try await controller.getInfo()
						}
						
						//adicionar o projeto na tabela
						dismiss()
					}, label: {
						ZStack{
							Text("Criar Entrega")
						}
					})
				}
			}
			.padding()
		}.frame(minWidth: 511, minHeight: 433)
	}
}

#Preview {
	CreateDeliveryView(task: TaskModel(id: 1, createdAt: Date.now, description: "Essa task precisa ser feita para ontem!", prototypeLink: "link do protótipo", taskLink: "link da task", status: "Status", taskName: "Task 1", designers: ["André Miguel", "Dani Brazolin Flauto"]))
		.environment(GeneralController())
}

extension CreateDeliveryView {
	private var cardTitle: some View {
		Text("Criar Entrega")
			.font(.title)
			.fontWeight(.semibold)
	}
	
	private var description: some View {
		Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. ")
			.font(.footnote)
			.foregroundColor(.gray)
	}
}
