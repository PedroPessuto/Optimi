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
    var task: TaskModel
    @Binding var updateDeliverySheetIsPresented: Bool
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
    
    @State var tagDescriptionPanelIsPresented: Bool = false
    @State var tagChosen: String = ""
    @State var tagDescription: String = ""
    @State var tagDesigner: String = ""
    @State var dateString: String = ""
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(delivery.deliveryName)")
                        .font(.title)
                    
                    StatusPill(status: delivery.deliveryStatus.rawValue)
                    
                    Spacer()
                    
                    Menu {
                        
                        Button {
                            updateDeliverySheetIsPresented = true
                        } label: {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Atualizar entrega")
                            }
                        }
                        
                        Button {
                            Task {
                                await controller.deleteDelivery(delivery, task.taskId!)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text("Deletar entrega")
                            }
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
#if os(macOS)
                            .foregroundColor(.secondary)
#endif
                    }
#if os(macOS)
                    .buttonStyle(PlainButtonStyle())
#endif
                }
                
					if let link = delivery.deliveryImplementationLink {
						if link != ""{
							HStack {
								 Image(systemName: "link")
								 Link("Implementação", destination: URL(string: link)!)
							}
							.foregroundStyle(Color.accentColor)
							.padding(.bottom,5)
#if os(macOS)
					 .font(.title2)
#endif
						}
						
					}
                

                
                HStack {
                    Image(systemName: "person.fill")
                    
                    Text("\(delivery.deliveryDevelopers ?? "Developers")")
                    
                    if let date = delivery.deliveryCreatedAt {
                        Text("\(formatter.string(from: date))")
                    }
                }.foregroundColor(.secondary)
                    .padding(.bottom,5)
                
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
                    if(controller.account?.accountRole == .Designer){
                        addFeedbackButton
                    }else{
                        noFeedbackView
                    }
                } else {
                    feedbackCard
                }
            }
            
        }
        .padding()
		 #if os(macOS)
        .sheet(isPresented: $createFeedbackViewIsPresented) {
            FeedbackGivingSheetView(task: task, feedbackList: $feedbacks, delivery: delivery)
        }
		 #endif
		 #if os(iOS)
		  .formSheet(isPresented: $createFeedbackViewIsPresented) {
			  FeedbackGivingSheetView(task: task, feedbackList: $feedbacks, delivery: delivery)
				  .environment(controller)
		  }
		 #endif

        
    }
}



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
    
    private var noFeedbackView: some View{
        VStack{
            Spacer()

            Text("Sem feedback ainda")
                .font(.title3)
                .padding(.leading, 30)
                .padding(.trailing, 30)
            Spacer()
        }
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
		Menu {
			Button {
				Task {
					await controller.deleteFeedback(feedbacks.first!)
					feedbacks.removeFirst()
				}
			} label: {
				HStack {
					Image(systemName: "trash.fill")
					Text("Deletar feedback")
				}
				.foregroundStyle(.red)
			}
			.buttonStyle(PlainButtonStyle())
			
		} label: {
			Image(systemName: "ellipsis.circle")
		}
		.buttonStyle(PlainButtonStyle())
        .foregroundStyle(.accent)
        .menuStyle(.borderlessButton)
	}
	
	private var feedbackDesignersAndDate: some View {
		HStack {
			Image(systemName: "person.fill")
			Text("\(feedbacks.first?.feedbackDesigner ?? "Designer")")
			
			Spacer()
			
			if let date = feedbacks.first?.feedbackCreatedAt {
				Text("\(formatter.string(from: date))")
					.onAppear { self.dateString = formatter.string(from: date) }
			}
		}
	}
	
	private var feedbackTags: some View {
		LazyVGrid(columns: gridRows) {
			
			ForEach(0..<(feedbacks.first?.feedbackTags.count ?? 0), id:\.self) { index in
				FeedbackTagCard(tag: feedbacks.first?.feedbackTags[index] ?? "",
									 dateString: formatter.string(from: feedbacks.first?.feedbackCreatedAt ?? Date.now),
									 description: feedbacks.first?.feedbackDescription[index] ?? "",
									 designer: feedbacks.first?.feedbackDesigner ?? "")
			}
			
		}
		
	}
}
