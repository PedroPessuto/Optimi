//
//  TagDescriptionView.swift
//  Optimi
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 19/04/24.
//

import SwiftUI

struct TagDescriptionView: View {
	
	var tag: String
	var description: String
	var designer: String
	var dateString: String
	
	@Environment(\.dismiss) private var dismiss
	@Environment(\.colorScheme) private var colorScheme
	
	var body: some View {
		NavigationStack {
			VStack(alignment: .leading) {
				
				HStack {
					Button {
						dismiss()
					} label: {
						Image(systemName: "xmark.circle.fill")
							.font(.title2)
							.padding(.bottom, 5)
							.foregroundStyle(colorScheme == .light ? .black : .secondary)
					}
					.buttonStyle(PlainButtonStyle())
					
					Spacer()
					
//					Button {
//						dismiss()
//					} label: {
//						Image(systemName: "ellipsis.circle")
//							.font(.title2)
//							.foregroundStyle(colorScheme == .light ? .black : .secondary)
//							.padding(.bottom)
//					}
//					.buttonStyle(PlainButtonStyle())
				}
				
				Divider()
				
				HStack {
					Text(tag)
						.font(.largeTitle)
						.fontWeight(.semibold)
						.foregroundStyle(.white)
					Spacer()
				}
				.foregroundStyle(tag == "Cor" ? Color.textRed : tag == "Espaçamento" ? Color.textBlue : tag == "Opacidade" ? Color.textYellow : tag == "Alinhamento" ? Color.textGreen : tag == "Imagem" ? Color.textOrange : tag == "Tamanho" ? Color.textRed : Color.textBlue)
				.padding(.top, 14)
				
				HStack {
					Image(systemName: "person.fill")
						.font(.title)
					Text(designer)
					Spacer()
					Text(dateString)
				}
				.foregroundStyle(tag == "Cor" ? Color.textRed : tag == "Espaçamento" ? Color.textBlue : tag == "Opacidade" ? Color.textYellow : tag == "Alinhamento" ? Color.textGreen : tag == "Imagem" ? Color.textOrange : tag == "Tamanho" ? Color.textRed : Color.textBlue)
				.padding(.bottom, 10)
				
				Text(description)
				Spacer()
				
			}
			.padding(.horizontal, 19)
			.padding(.bottom, 30)
			.padding(.top)

		}
	}
}

#Preview {
	TagDescriptionView(tag: "Cor", description: "Lorem ipsum dolor set in ", designer: "Nome do Desginer", dateString: "27/03/2024 - 17:07")
}

extension TagDescriptionView {
	
}

