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
				
				Spacer()
				
//            if feedback == nil {
//                HStack {
//                    Spacer()
//                    addFeedback
//                        .fixedSize(horizontal: true, vertical: true)
//                }
//            }
//            else {
//                VStack(alignment: .leading) {
//                    HStack {
//
//                        feedbacksTitle
//
//                        Spacer()
//
//                        //feedbackButtons
//                    }
//
//                    Text(feedback!.description)
//                        .fixedSize(horizontal: true, vertical: true)
//                }
//                .frame(minWidth: 260, maxWidth: 350)
//            }
		  }
		  .padding()
	 }
}
