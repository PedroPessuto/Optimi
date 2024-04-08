//
//  DeliveryView.swift
//  Optimi
//
//  Created by Pedro Pessuto on 28/03/24.
//

import SwiftUI

struct DeliveryView: View {
	
	@Environment(GeneralController.self) var controller
	@Environment(\.dismiss) private var dismiss
	
	@State var deliveries: [DeliveryModel] = []
	
	@State var noDeliveriesFound: Bool = false
	
	@State var createDeliverySheetIsPresented: Bool = false
	
	var task: TaskModel
	
	var body: some View {
		NavigationStack{
			if noDeliveriesFound {
				Text("Nenhuma Entrega Encontrada...")
					.font(.largeTitle)
					.fontWeight(.semibold)
			}
			else if deliveries.isEmpty {
				Text("Carregando Entregas...")
					.font(.largeTitle)
					.fontWeight(.semibold)
					.onAppear {
						DispatchQueue.main.asyncAfter(deadline: .now()+10) {
							if deliveries.isEmpty {
								noDeliveriesFound.toggle()
							}
						}
					}
			}
			else {
				List{
					ForEach(deliveries, id:\.self) { delivery in
						DeliveryCard(delivery: delivery)
					}
				}
			}
		}
		.onAppear {
			Task {
				do {
					self.deliveries = try await controller.getDeliveries(from: task)
				} catch {
					print("Error fetching deliveries: \(error)")
				}
			}
		}
		.sheet(isPresented: $createDeliverySheetIsPresented) {
			CreateDeliveryView(task: task)
		}
		.toolbar {
			ToolbarItemGroup(placement: .automatic) {
				HStack {
					
					Button {
						dismiss()
					} label: {
						Image(systemName: "folder")
					}
					
					Button {
						controller.currentScreen = "Delivery"
					} label: {
						Image(systemName: "bubble.left.and.text.bubble.right")
					}
					.disabled(true)
					
					Divider()
					
					Button {
						createDeliverySheetIsPresented.toggle()
					} label: {
						Image(systemName: "plus")
					}
					.buttonStyle(PlainButtonStyle())
				}
			}
		}
		.navigationBarBackButtonHidden(true)
	}
}

#Preview {
	DeliveryView(deliveries: [
		DeliveryModel(name: "Entrega 2", documentation: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris lacinia sagittis leo, eget malesuada magna varius eget. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris lacinia sagittis leo, eget malesuada magna varius eget.", implementationLink: "vrvrvrv", status: "Status", developer: "Marina"),
		DeliveryModel(name: "Entrega 1", documentation: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris lacinia sagittis leo, eget malesuada magna varius eget. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris lacinia sagittis leo, eget malesuada magna varius eget.", implementationLink: "vrvrvrv", status: "Status", developer: "Angela")], task:
						TaskModel(id: 1, createdAt: Date.now, description: "Essa é a primeira task", prototypeLink: "link prototipo", taskLink: "link tarefa", status: "Ready for Dev!", taskName: "Task Uno!", designers: ["André Miguel", "Dani Brazolin Flauto"]))
}
