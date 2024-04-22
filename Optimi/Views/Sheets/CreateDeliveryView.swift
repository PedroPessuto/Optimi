//
// CreateTaskView.swift
// rendy
//
// Created by Marina Martin on 02/04/24.
//

import SwiftUI
import Aptabase


struct CreateDeliveryView: View {
	
	@Environment(\.dismiss) private var dismiss
	
	@Environment(GeneralController.self) var controller
	
	@State public var deliveryName: String = ""
	@State public var deliveryDescription: String = ""
	@State public var implementationLink: String = ""
	@State public var deliveryDevelopers: String = ""
	
	var task: TaskModel
	
	var body: some View {
		NavigationStack{
			VStack(alignment: .leading){
				
				Text("Criar Entrega")
					.font(.title)
					.bold()
					.padding(.bottom, 14)
				
//				Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. ")
//					.font(.footnote)
//					.foregroundColor(.gray)
//					.padding(.bottom, 22)
				
				Text("Nome da Entrega")
					.font(.headline)
					.fontWeight(.semibold)
				
				TextField("Nome da Entrega", text: $deliveryName)
					.textFieldStyle(.roundedBorder)
					.padding(.bottom, 14)
				
				Text("Descrição da Entrega")
					.font(.headline)
					.fontWeight(.semibold)
					.padding(.bottom, 5)
				
				VStack {
//					TextEditor(text: $deliveryDescription)
//						.scrollDisabled(true)
//						.scrollIndicators(.never)
					TextField("", text: $deliveryDescription, prompt: Text("Descrição"), axis: .vertical)
						.lineLimit(5...10)
				}
				.cornerRadius(5)
				.padding(.bottom, 14)
				
				
				VStack(alignment: .leading) {
					Text("Link do Vídeo/Foto")
						.font(.headline)
						.fontWeight(.semibold)
					
					TextField("Link", text: $implementationLink)
						.textFieldStyle(.roundedBorder)
				}
				
				.padding(.bottom, 14)
				
				
				Text("Developers")
					.font(.headline)
					.fontWeight(.semibold)
					.padding(.bottom, 7)
				
				TextField("Developers", text: $deliveryDevelopers)
					.padding(.bottom, 26)
				
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
						Task {
							let delivery = DeliveryModel(deliveryName: deliveryName, deliveryDevelopers: deliveryDevelopers, deliveryDocumentation: deliveryDescription, deliveryImplementationLink: implementationLink)
							await controller.createDelivery(delivery, task.taskId!)
						}
						dismiss()
						Aptabase.shared.trackEvent("Criou uma delivery")
					}, label: {
						ZStack{
							Text("Criar Entrega")
						}
					})
                    #if os(macOS)
                    .keyboardShortcut(.defaultAction)
                    #endif
					.disabled(deliveryName == "" || deliveryDescription == "")
				}
			}
			.padding()
		}.frame(minWidth: 511, minHeight: 450)
		
	}
}
