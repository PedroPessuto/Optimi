//
//  UpdateDeliveryView.swift
//  Optimi
//
//  Created by Pedro Pessuto on 23/04/24.
//

import SwiftUI
import Aptabase

struct UpdateDeliveryView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(GeneralController.self) var controller
    
    @State public var deliveryName: String = ""
    @State public var deliveryDescription: String = ""
    @State public var implementationLink: String = ""
    @State public var deliveryDevelopers: String = ""
    
    var delivery: DeliveryModel
    
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                
                Text("Atualizar Entrega")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 14)
                
                Text("Nome da Entrega")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                TextField("Nome da Entrega", text: $deliveryName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom, 14)
                
                Text("Descrição da Entrega")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.bottom, 5)
                
                VStack {
                    //                    TextEditor(text: $deliveryDescription)
                    //                        .scrollDisabled(true)
                    //                        .scrollIndicators(.never)
                    TextField("", text: $deliveryDescription, prompt: Text("Descrição"), axis: .vertical)
                        .lineLimit(5...10)
                }
                .cornerRadius(5)
                .padding(.bottom, 14)
                
                
                VStack(alignment: .leading) {
                    Text("Link do Vídeo/Foto")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    TextField("Link", text: $implementationLink)
                        .textFieldStyle(.roundedBorder)
                }
                
                .padding(.bottom, 14)
                
                
                Text("Developers")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.bottom, 7)
                
                TextField("Developers", text: $deliveryDevelopers)
                    .padding(.bottom, 26)
                
                HStack{
                    Spacer()
                    Button(action: {
                        dismiss()
                    }, label: {
                        ZStack{
                            Text("Cancelar")
                        }
                    })
                    Button(action: {
                        Task {
                            delivery.deliveryName = deliveryName
                            delivery.deliveryDocumentation = deliveryDescription
                            delivery.deliveryImplementationLink = implementationLink
                            delivery.deliveryDevelopers = deliveryDevelopers
                            
                            await controller.updateDelivery(delivery)
                            dismiss()
                        }
                    
                        Aptabase.shared.trackEvent("Atualizou uma delivery")
                    }, label: {
                        ZStack{
                            Text("Atualizar Entrega")
                        }
                    })
                }
            }
            .padding()
        }.frame(minWidth: 511, minHeight: 450)
            .onAppear {
                deliveryName = delivery.deliveryName
                deliveryDescription = delivery.deliveryDocumentation ?? ""
                implementationLink = delivery.deliveryImplementationLink ?? ""
                deliveryDevelopers = delivery.deliveryDevelopers ?? ""
                
            }
        
    }
}
