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
	
	@State var feedbacks: [FeedbackModel] = []

	 
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
					 }
					 
					 HStack{
						  Image(systemName: "link")
						 Link("Implementação", destination: URL(string: delivery.deliveryImplementationLink ?? "")!)
					 }.foregroundStyle(.blue)
						  .font(.title2)
					 
					 HStack {
						  Image(systemName: "person.fill")
						  
						  Text("\(delivery.deliveryDevelopers)")
						  
						 Text("\(delivery.deliveryCreatedAt)")
//                    if let date = delivery.created_At {
//                        Text("\(formatter.string(from: date))")
//                    }
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
						await controller.getFeedbacks()
					}
				}
				
				Spacer()
				
			  feedbackCard
		  }
		  .padding()
	 }
}

//#Preview {
//	DeliveryCard(delivery: DeliveryModel(deliveryName: "Eita preula"))
//		.environment(GeneralController())
//}

extension DeliveryCard {
	
	private var feedbackCard: some View {
		HStack {
			feedbackTitle
			Spacer()
			feedbackButton
		}
		
		
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
	}
	
	private var feedbackDesignersAndDate: some View {
		HStack {
			Image(systemName: "person.fill")
			
		}
	}
	
}
