//
//  FeedbackGivingSheetView.swift
//  Optimi
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 12/04/24.
//

import SwiftUI
import Aptabase


struct FeedbackGivingSheetView: View {
	
	@Environment(\.dismiss) private var dismiss
	@Environment(GeneralController.self) var controller
	
	// var delivery: DeliveryModel
	
	@State var feedbackStatusSelection = ""
	@State var feedbackTags: [String] = []
	@State var feedbackDescription: [String] = []
	
	@State var tagSelections: [String] = [""]
	@State var pickerTagDescription: [String] = [""]
    var task: TaskModel
    @Binding var feedbackList: [FeedbackModel]
    var delivery: DeliveryModel

	@Environment(\.defaultMinListRowHeight) var rowHeight
	
   
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("Feedback")
				.font(.largeTitle)
				.fontWeight(.bold)
				.padding(.bottom, 14)
			
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
						}
                        .pickerStyle(.automatic)
                        .frame(width: 120)
						
//						TextEditor(text: $pickerTagDescription[index])
//							.scrollIndicators(.never)
//							.padding(4)
//							.background(RoundedRectangle(cornerRadius: 4).stroke())
						TextField("", text: $pickerTagDescription[index], prompt: Text("Descrição"), axis: .vertical)
							.padding(4)
							.background(RoundedRectangle(cornerRadius: 4).stroke(Color(red: 128/256, green: 128/256, blue: 128/256)))
					}
				}
			}
			.scrollContentBackground(.hidden)
			.frame(height: rowHeight*CGFloat(tagSelections.count)+100)
			
			Spacer()
			
			HStack {
				Spacer()
				
				Button("Cancelar") {
					dismiss()
				}
				
                if feedbackList.count > 0 {
                    Button("Atualizar Feedback") {
                        dismiss()
                        Task {
                            feedbackList[0].feedbackStatus = feedbackStatusSelection
                            feedbackList[0].feedbackTags = tagSelections
                            feedbackList[0].feedbackDescription = pickerTagDescription
                            await controller.updateFeedback(feedbackList[0], delivery, task)
                        }
                        Aptabase.shared.trackEvent("Atualizou um feedback")
                    }
                    .keyboardShortcut(.defaultAction)
                }
                else {
                    Button("Enviar Feedback") {
                        Task {
                            let feedback = FeedbackModel(
                                feedbackStatus: feedbackStatusSelection,
                                feedbackTags: tagSelections.isEmpty ? [] : tagSelections.first == "" && tagSelections.count == 1 ? [""] : tagSelections,
                                feedbackDescription: pickerTagDescription.isEmpty ? [] : pickerTagDescription.first == "" && pickerTagDescription.count == 1 ? [""] : pickerTagDescription, feedbackDesigner: controller.account?.accountName ?? "Designer")
                            
                            let response = await controller.createFeedback(feedback, delivery, task)
                            
                            feedbackList.append(response ?? feedback)
                            
                            dismiss()
                        }
                        Aptabase.shared.trackEvent("Criou um feedback")
                    }
                    .keyboardShortcut(.defaultAction)
                }
			}
			
		}
		.padding()
		.frame(minWidth: 450, maxWidth: 500, minHeight: 380, maxHeight: 500)
        .onAppear {
            if self.feedbackList.count > 0 {
                feedbackStatusSelection = feedbackList[0].feedbackStatus ?? ""
                feedbackTags = feedbackList[0].feedbackTags
                tagSelections = feedbackList[0].feedbackTags
                pickerTagDescription =  feedbackList[0].feedbackDescription
                feedbackDescription = feedbackList[0].feedbackDescription
            }
        }
	}
}



