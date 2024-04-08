//
//  DeliveryCard.swift
//  Optimi
//
//  Created by Marina Martin on 03/04/24.
//

import SwiftUI

struct DeliveryCard: View {
	
	@Environment(GeneralController.self) var controller
	@State var createFeedbackViewIsPresented: Bool = false
	
	var delivery: DeliveryModel
	
	var formatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd/MM/yyyy - hh:mm"
		return formatter
	}
	
	@State var feedback: FeedbackModel? = nil
	
	var body: some View {
		HStack(alignment: .top) {
			VStack(alignment: .leading) {
				HStack {
					name
					
					deliveryStatus
					
					Spacer()
					
					deleteDelivery
					
					editDelivery
				}
				
				implementationLink
				
				HStack {
					//					Image(systemName: "person.fill")
					//						.foregroundColor(.gray)
					
					Text("\(delivery.developer ?? "")")
					
					if let date = delivery.created_At {
						Text("\(formatter.string(from: date))")
					}
				}
				
				HStack {
					Text("\(delivery.documentation)")
						.multilineTextAlignment(.leading)
					
					Spacer()
				}
				
				
			}
			.frame(minWidth: 418, maxWidth: 550)
			
			Spacer()
			
			if feedback == nil {
				HStack {
					Spacer()
					addFeedback
						.fixedSize(horizontal: true, vertical: true)
				}
			}
			else {
				VStack(alignment: .leading) {
					HStack {
						
						feedbacksTitle
						
						Spacer()
						
						feedbackButtons
					}
					
					Text(feedback!.description)
						.fixedSize(horizontal: true, vertical: true)
				}
				.frame(minWidth: 260, maxWidth: 350)
			}
		}
		.padding()
		.onAppear {
			Task {
				do {
					if let feedback = try await controller.getFeedback(from: delivery) {
						self.feedback = feedback
					}
				} catch {
					print("Error fetching feedback: \(error)")
				}
			}
		}
	}
}


#Preview {
	DeliveryCard(delivery: DeliveryModel(created_At: Date.now, name: "Entrega 2 waaaaaaa", documentation: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris lacinia sagittis leo, eget malesuada magna varius eget. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris lacinia sagittis leo, eget malesuada magna varius eget.", implementationLink: "vrvrvrv", status: "Status", developer: "Marina"))
}

extension DeliveryCard {
	private var name: some View {
		Text("\(delivery.name)")
			.font(.title)
	}
	
	private var deliveryStatus: some View {
		Text("\(delivery.status)")
			.padding(.horizontal)
			.padding(.vertical, 5)
			.background()
			.clipShape(RoundedRectangle(cornerRadius: 360))
	}
	
	private var deleteDelivery: some View {
		Button {
			//
		} label: {
			Image(systemName: "trash")
				.foregroundColor(.red)
		}
		.buttonStyle(PlainButtonStyle())
	}
	
	private var editDelivery: some View {
		Button {
			
		} label: {
			Image(systemName: "pencil")
		}
		.buttonStyle(PlainButtonStyle())
	}
	
	private var addFeedback: some View {
		Button {
			createFeedbackViewIsPresented.toggle()
		} label: {
			Text("Adicionar Feedback")
				.font(.title3)
			Image(systemName: "plus")
		}.sheet(isPresented: $createFeedbackViewIsPresented){
			CreateFeedbackView(delivery: delivery)
		}
	}
	
	private var implementationLink: some View {
		HStack{
			Image(systemName: "link")
				.foregroundStyle(.blue)
			Link("Implementação", destination: URL(string: delivery.implementationLink)!)
		}
	}
	
	private var feedbacksTitle: some View {
		Text("Feedbacks")
			.font(.title)
	}
	
	private var feedbackButtons: some View {
		HStack {
			Button {
				// delete feedback
			} label: {
				Image(systemName: "trash")
					.foregroundStyle(.red)
			}
			.buttonStyle(PlainButtonStyle())
			
			Button {
				// edit feedback
			} label: {
				Image(systemName: "pencil")
					.foregroundStyle(.secondary)
			}
			.buttonStyle(PlainButtonStyle())
		}
	}
	
}
