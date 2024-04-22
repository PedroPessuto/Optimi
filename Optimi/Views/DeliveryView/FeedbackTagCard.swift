//
//  FeedbackTagCard.swift
//  Optimi
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 19/04/24.
//

import SwiftUI

struct FeedbackTagCard: View {
	
	@State var tagDescriptionPanelIsPresented: Bool = false
	
	var formatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd/MM/yyyy - hh:mm"
		return formatter
	}
	
	var tag: String
	var dateString: String
	var description: String
	var designer: String
	
	var body: some View {
		NavigationStack {
			Button {
				tagDescriptionPanelIsPresented.toggle()
			} label: {
				Text("\(tag)")
			}
			.buttonStyle(PlainButtonStyle())
			.padding(.horizontal, 5)
			.padding(.vertical, 1)
			.background(tag == "Cor" ? Color.backgroundRed : tag == "Espaçamento" ? Color.backgroundBlue : tag == "Opacidade" ? Color.backgroundYellow : tag == "Alinhamento" ? Color.backgroundGreen : tag == "Imagem" ? Color.backgroundOrange : tag == "Tamanho" ? Color.backgroundRed : Color.backgroundBlue)
			.clipShape(RoundedRectangle(cornerRadius: 3))
			
			
		}
#if os(macOS)
		.floatingPanel(isPresented: $tagDescriptionPanelIsPresented) {
			ZStack {
				VisualEffectView(material: .sidebar, blendingMode: .behindWindow, state: .followsWindowActiveState, emphasized: true)
				TagDescriptionView(tag: tag,
										 description: description,
										 designer: designer,
										 dateString: dateString)
			}
			.frame(minWidth: 272, maxWidth: 320, minHeight: 250, maxHeight: 270)
			
		}
#endif
#if os(iOS)
		.popover(isPresented: $tagDescriptionPanelIsPresented) {
			TagDescriptionView(tag: tag,
									 description: description,
									 designer: designer,
									 dateString: dateString)
			.frame(minWidth: 272, maxWidth: 320, minHeight: 250, maxHeight: 270)
		}
#endif
		
		
	}
}

#Preview {
	FeedbackTagCard(tag: "Cor", dateString: "DIAAA", description: "Descrição", designer: "Paulo Sonzzini")
}
