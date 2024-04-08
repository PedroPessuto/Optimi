//
//  CreateFeedbackView.swift
//  Optimi
//
//  Created by Marina Martin on 04/04/24.
//

import SwiftUI

struct CreateFeedbackView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(GeneralController.self) var controller
	
	@State public var feedbackDescription: String = ""
	@State public var feedbackStatus: String = ""
	//@State public var feedbackTags: [String] = ""
	//@State public var feedbackDesigners: [String] = ""
	
	var delivery: DeliveryModel
	
	var body: some View {
		NavigationStack{
			VStack(alignment: .leading){
				Text("Criar Feedback")
					.font(.title)
				
				HStack{
					Text("\(delivery.name)")
					
					Image(systemName: "link")
						.foregroundStyle(.blue)
					
					//link do Feedback
					Link("Review", destination: URL(string: delivery.implementationLink)!)
				}.font(.subheadline)
				
				Text("Status da Entrega")
					.font(.headline)
				Picker("", selection: $feedbackStatus){
					Text("Aprovado").tag("Aprovado")
					Text("Reprovado").tag("Reprovado")
				}.pickerStyle(.segmented)
				
				Text("Descrição do Feedback")
					.font(.headline)
				TextField("Descrição", text: $feedbackDescription)
				
				
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
						
						var feedback: FeedbackModel? = FeedbackModel(description: feedbackDescription, feedbackStatus: feedbackStatus)
						
						Task {
							feedback = await controller.supabaseController.insertOneAndReturn(tableName: "Feedback", object: feedback!)
							
							controller.viewController.delivery = delivery
							
							
							var delivery_feedback: DeliveryFeedbackModel? = nil
							
							if let y = feedback {
								delivery_feedback = DeliveryFeedbackModel(idDelivery: controller.viewController.delivery?.id, idFeedback: y.id)
								
								if let x = delivery_feedback{
									delivery_feedback = await controller.supabaseController.insertOneAndReturn(tableName: "Delivery-Feedback", object: x)
								}
							}
						}
						dismiss()
					}, label: {
						ZStack{
							Text("Enviar Feedback")
						}
					})
				}
			}.padding()
		}
		.frame(minWidth: 452, maxWidth: 752, minHeight: 381, maxHeight: 581)
	}
}
