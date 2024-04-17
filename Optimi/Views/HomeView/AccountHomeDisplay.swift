//
//  AccountHomeDisplay.swift
//  Optimi
//
//  Created by Pedro Pessuto on 10/04/24.
//

import SwiftUI

struct AccountHomeDisplay: View {
    
    @Environment(GeneralController.self) private var generalController
    
    private var action: () -> Void
    private var iconColor: Color
    private var iconSize: CGFloat
    private var roleSize: CGFloat
    private var nameSize: CGFloat
    
    init(action: @escaping () -> Void) {
        self.action = action
#if os(iOS)
        self.iconColor = .accentColor
        self.iconSize = 30
        self.roleSize = 15
        self.nameSize = 20
        
#endif
#if os(macOS)
        self.iconColor = .gray
        self.iconSize = 20
        self.roleSize = 10
        self.nameSize = 12
#endif
    }
    
    var body: some View {
        
        Button (action: {action()}) {
            HStack {
                
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: iconSize, height: iconSize)
                    .foregroundStyle(iconColor)
                
                VStack(alignment: .leading , spacing: 0) {
                    Text(generalController.account?.accountRole.rawValue ?? "Nenhum Cargo")
                        .font(.system(size: roleSize))
                        .fontWeight(.thin)
                    
                    HStack {
                        Text(generalController.account?.accountName ?? "Seu Nome")
                            .font(.system(size: nameSize))
                            .fontWeight(.regular)
#if os(macOS)
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: nameSize, height: nameSize)
#endif
                    }
                    
                }
            }
        }
            .buttonStyle(.plain)
        .foregroundColor(.gray)
        
    }
}
