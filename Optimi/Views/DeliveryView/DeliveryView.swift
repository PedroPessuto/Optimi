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
    @State var updateDeliverySheetIsPresented: Bool = false
    @State var createDeliverySheetIsPresented: Bool = false
    
    @State var currentScreen: ScreenNames = .DeliveryView
    
    var task: TaskModel
    
    var body: some View {
        NavigationStack{
            //Falta um if pra mostrar um empty state se tiver 0 Deliverys

			  if !task.taskDeliveries.isEmpty {
				  List{
						ForEach(task.taskDeliveries, id:\.deliveryId) { delivery in
							DeliveryCard(delivery: delivery, task: task)
						}
				  }
			  } 
			  else {
				  Text("Nenhuma entrega feita...")
					  .font(.largeTitle)
					  .fontWeight(.semibold)
			  }
            
        }
        .onAppear {
			  print("Apareci")
            Task {
                
                await controller.getDeliveriesFromTask(task)
                
            }
        }

		  .onChange(of: task.taskId) { oldValue, newValue in
			  Task {
				  await controller.getDeliveriesFromTask(task)
			  }
		  }
#if os(macOS)
		  .sheet(isPresented: $createDeliverySheetIsPresented) {
			  CreateDeliveryView(task: task)
		  }
#endif
#if os(iOS)
		  .formSheet(isPresented: $createDeliverySheetIsPresented) {
			  CreateDeliveryView(task: task)
				  .environment(controller)
		  }
#endif
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
#if os(macOS)
						 Divider()
#endif
						 
                    Button {
                        createDeliverySheetIsPresented.toggle()
                    } label: {
                        HStack {
                            Text("Adicionar entrega")
                            Image(systemName: "plus")

                        }
                        .buttonStyle(PlainButtonStyle())
                    }.foregroundColor(.secondary)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
