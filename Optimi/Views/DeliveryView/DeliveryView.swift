//
//  DeliveryView.swift
//  rendy
//
//  Created by Pedro Pessuto on 28/03/24.
//

import SwiftUI

struct DeliveryView: View {
	 
	 @Environment(GeneralController.self) var controller
	 @Environment(\.dismiss) private var dismiss
	 
	 @State var noDeliveriesFound: Bool = false
	 @State var createDeliverySheetIsPresented: Bool = false
	 
	@State var currentScreen: ScreenNames = .DeliveryView
	 
	 var task: TaskModel
	 
	 var body: some View {
		  NavigationStack{
				//Falta um if pra mostrar um empty state se tiver 0 Deliverys
				List{
					ForEach(task.taskDeliveries, id:\.deliveryId) { delivery in
						  DeliveryCard(delivery: delivery)
					 }
				}
		  }
		  .onAppear {
			  Task {
				  
				  await controller.getDeliveriesFromTask(task)
				  
			  }
		  }
		  .sheet(isPresented: $createDeliverySheetIsPresented) {
				CreateDeliveryView(task: task)
		  }
		  .toolbar {
				ToolbarItem(placement: .confirmationAction) {
					 Picker("CurrentScreen", selection: $currentScreen){
						 Text("Task").tag(ScreenNames.TaskView)
						 Text("Feedback").tag(ScreenNames.DeliveryView)
					 }.pickerStyle(.segmented)
						  .onChange(of: currentScreen) {
								controller.screen = currentScreen
						  }
				}
				
				ToolbarItemGroup(placement: .automatic) {
					 HStack {
						  
						  Divider()
						  
						  
						  
						  Button {
								createDeliverySheetIsPresented.toggle()
						  } label: {
							  HStack {
								  Text("Adicionar entrega")
								  Image(systemName: "plus")
							  }
						  }
						  .buttonStyle(PlainButtonStyle())
					 }.foregroundColor(.secondary)
				}
		  }
		  .navigationBarBackButtonHidden(true)
	 }
}
