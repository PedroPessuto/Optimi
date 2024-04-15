//
//  FeedbackGivingSheetView.swift
//  Optimi
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 12/04/24.
//

import SwiftUI

struct FeedbackGivingSheetView: View {
	
	@Environment(\.dismiss) private var dismiss
	@Environment(GeneralController.self) var controller
	
	// var delivery: DeliveryModel
	
	@State var feedbackStatusSelection = ""
	@State var feedbackTags: [String] = []
	@State var feedbackDescription: [String] = []
	
	@State var tagSelections: [String] = [""]
	@State var pickerTagDescription: [String] = [""]
	
	@Environment(\.defaultMinListRowHeight) var rowHeight
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("Feedback")
				.font(.largeTitle)
				.fontWeight(.bold)
			
//			 HStack {
//				 Text("\(delivery.deliveryName)")
//
//				 HStack {
//					 Image(systemName: "link")
//					 Link("Review", destination: delivery.deliveryURL)
//				 }
//				 .foregroundStyle(.blue)
//			 }
			
			Text("Status da Entrega")
				.fontWeight(.semibold)
			
			Picker("", selection: $feedbackStatusSelection) {
				Text("Aprovada").tag("Aprovada")
				Text("Reprovada").tag("Reprovada")
			}
			.pickerStyle(.segmented)
			.frame(width: 180)
			
			List {
				Button {
					withAnimation(.spring()) {
						tagSelections.append("")
						pickerTagDescription.append("")
					}
				} label: {
					Image(systemName: "plus")
				}
				ForEach(0..<tagSelections.count, id: \.self) { index in
					HStack {
						Button {
							withAnimation(.easeInOut(duration: 0.3)) {
								tagSelections.remove(at: index)
								pickerTagDescription.remove(at: index)
							}
						} label: {
							Image(systemName: "minus.circle.fill")
								.foregroundStyle(.red)
						}
						.buttonStyle(PlainButtonStyle())
						Picker("", selection: $tagSelections[index]) {
							Text("Cor").tag("Cor")
							Text("Alinhamento").tag("Alinhamento")
							Text("Texto").tag("Texto")
							Text("Espaçamento").tag("Espaçamento")
							Text("Imagem").tag("Imagem")
							Text("Opacidade").tag("Opacidade")
							Text("Tamanho").tag("Tamanho")
						}.pickerStyle(.automatic)
							.frame(width: 120)
						
						TextEditor(text: $pickerTagDescription[index])
							.scrollIndicators(.never)
							.padding(4)
							.background(RoundedRectangle(cornerRadius: 4).stroke())
					}
				}
			}
			.scrollContentBackground(.hidden)
			.frame(height: rowHeight*CGFloat(tagSelections.count)+100)
			
			HStack {
				Spacer()
				
				Button("Cancelar") {
					dismiss()
				}
				
				Button("Enviar Feedback") {
					Task {
						let feedback = FeedbackModel(
							feedbackStatus: feedbackStatusSelection,
							feedbackTags: tagSelections.isEmpty ? [] : tagSelections.first == "" && tagSelections.count == 1 ? [""] : tagSelections,
							feedbackDescription: pickerTagDescription.isEmpty ? [] : pickerTagDescription.first == "" && pickerTagDescription.count == 1 ? [""] : pickerTagDescription)
						
						await controller.createFeedback(feedback)
						
						dismiss()
					}
				}
				.keyboardShortcut(.defaultAction)
			}
			
		}
		.padding()
	}
}

#Preview {
	FeedbackGivingSheetView()
		.environment(GeneralController())
}


