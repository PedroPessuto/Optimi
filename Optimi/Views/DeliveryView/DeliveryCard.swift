//
//  DeliveryCardView.swift
//  Optimi
//
//  Created by Marina Martin on 12/04/24.
//


import SwiftUI

struct DeliveryCard: View {
	
	@Environment(GeneralController.self) var controller
	
	var delivery: DeliveryModel
	
	@State var createFeedbackViewIsPresented: Bool = false
	
	var formatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd/MM/yyyy - hh:mm"
		return formatter
	}
	
	private let gridRows = [
		GridItem(.adaptive(minimum: 77, maximum: 100), alignment: .leading)
	]
	
	@State var feedbacks: [FeedbackModel] = []
	@State var isLoading: Bool = false
	
	
	var body: some View {
		HStack(alignment: .top) {
			VStack(alignment: .leading) {
				HStack {
					Text("\(delivery.deliveryName)")
						.font(.title)
					
					StatusPill(status: delivery.deliveryStatus.rawValue)
					
					Spacer()
					
					Button {
						//aqui edita ou deleta
					} label: {
						Image(systemName: "ellipsis.circle")
							.foregroundColor(.secondary)
					}
					.buttonStyle(PlainButtonStyle())
				}
				
				HStack{
					Image(systemName: "link")
					Link("Implementação", destination: URL(string: delivery.deliveryImplementationLink ?? "")!)
				}.foregroundStyle(.blue)
					.font(.title2)
				
				HStack {
					Image(systemName: "person.fill")
					
					Text("\(delivery.deliveryDevelopers)")
					
					//						 Text("\(delivery.deliveryCreatedAt)")
					if let date = delivery.deliveryCreatedAt {
						Text("\(formatter.string(from: date))")
					}
				}.foregroundColor(.secondary)
				
				HStack {
					Text("\(delivery.deliveryDocumentation ?? "")")
						.multilineTextAlignment(.leading)
					
					Spacer()
				}
				
				
			}
			.frame(minWidth: 318, maxWidth: 550)
			.onAppear {
				Task {
					self.isLoading = true
					
					self.feedbacks = await controller.getFeedbacksFromDelivery(delivery)
					
					self.isLoading = false
				}
			}
			
			Spacer()
			
			if isLoading {
				HStack {
					Spacer()
					Text("Carregando feedbacks...")
						.foregroundStyle(.secondary)
				}
			}
			else {
				if feedbacks.isEmpty {
					addFeedbackButton
				} else {
					feedbackCard
				}
			}
			
		}
		.padding()
		.sheet(isPresented: $createFeedbackViewIsPresented) {
			FeedbackGivingSheetView(delivery: delivery)
		}
	}
}

//#Preview {
//	DeliveryCard(delivery: DeliveryModel(deliveryName: "Eita preula"))
//		.environment(GeneralController())
//}

extension DeliveryCard {
	private var addFeedbackButton: some View {
		Button {
			createFeedbackViewIsPresented.toggle()
		} label: {
			HStack {
				Text("Adicionar Feedback")
				Image(systemName: "plus")
			}
			.foregroundStyle(.secondary)
		}
		.buttonStyle(PlainButtonStyle())
	}
	
	private var feedbackCard: some View {
		VStack {
			HStack {
				feedbackTitle
				Spacer()
				feedbackButton
			}
			feedbackDesignersAndDate
			
			feedbackTags
			Spacer()
		}
		.frame(minWidth: 250, maxWidth: 300, minHeight: 125, maxHeight: 150)
		.padding(.trailing, 25)
	}
	
	private var feedbackTitle: some View {
		Text("Feedbacks")
			.font(.largeTitle)
			.fontWeight(.semibold)
	}
	
	private var feedbackButton: some View {
		Button {
			
		} label: {
			Image(systemName: "ellipsis.circle")
				.foregroundStyle(.secondary)
		}
		.buttonStyle(PlainButtonStyle())
	}
	
	private var feedbackDesignersAndDate: some View {
		HStack {
			Image(systemName: "person.fill")
			//			Text("\(feedbacks.first. ?? "")")
			Spacer()
			//			if let date = feedbacks.first.createdAt
		}
	}
	
	private var feedbackTags: some View {
		LazyVGrid(columns: gridRows, spacing: 20) {
			ForEach(feedbacks.first?.feedbackTags ?? [], id:\.self) { item in
				Text("\(item)")
					.padding(.horizontal, 5)
					.padding(.vertical, 1)
					.background(item == "Cor" ? Color.backgroundRed : item == "Espaçamento" ? Color.backgroundBlue : item == "Opacidade" ? Color.backgroundYellow : item == "Alinhamento" ? Color.backgroundGreen : item == "Imagem" ? Color.backgroundOrange : item == "Tamanho" ? Color.backgroundRed : Color.backgroundBlue)
					.clipShape(RoundedRectangle(cornerRadius: 3))
			}
		}
	}
	
}
