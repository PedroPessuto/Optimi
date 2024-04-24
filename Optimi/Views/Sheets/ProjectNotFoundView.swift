//
//  ProjectNotFoundView.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import SwiftUI

struct ProjectNotFoundView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        #if os(macOS)
         NavigationStack {
             VStack(alignment: .leading) {
                 Text("Projeto não encontrado")
                     .font(.largeTitle)
                     .padding(.bottom, 5)
                 
                 Text("Confirme o Token do projeto")
                     .padding(.bottom)
                 
                 HStack {
                     Spacer()
                     
                     Button {
                         dismiss()
                     } label: {
                         Text("Fechar")
                     }
                 }
             }
             .padding()
         }
         .frame(minWidth: 289, maxWidth: 350, minHeight: 138, maxHeight: 250)
        #endif
        
        #if os(iOS)
        
        NavigationStack{
            VStack(alignment: .leading) {
                Text("Projeto não encontrado")
                    .font(.largeTitle)
                    .padding(.bottom, 5)
                
                Text("Confirme o Token do projeto")
                    .font(.subheadline)
                    .padding(.bottom)
            }.toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button {
                        dismiss()
                    } label: {
                        Text("Fechar")
                    }
                }
            }
            .padding()
        }
		  .frame(minWidth: 300, maxWidth: 400, minHeight: 140, maxHeight: 250)
        
        #endif
    }
}
