//
//  ProjectNotFoundView.swift
//  Optimi
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 01/04/24.
//

import SwiftUI

struct ProjectNotFoundView: View {
	
	@Environment(\.dismiss) private var dismiss
	
	var body: some View {
		NavigationStack {
			VStack(alignment: .leading) {
				Text("Projeto não encontrado")
					.font(.largeTitle)
				
				Text("Confirme o Token do projeto")
				
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
	}
}

#Preview {
	ProjectNotFoundView()
}
