//
//  oButton.swift
//  Optimi
//
//  Created by Pedro Pessuto on 09/04/24.
//

import SwiftUI

enum oButtonVariants {
    case fill
    case outline
}


struct oButton: View {
    
    private var config: Config
    
    var body: some View {
        
      
#if os(iOS)
        // Tem que fazer separado, pois ifs ternários não funcionam nesse caso do buttonStyle
        if (config.variant == .fill) {
            Button(action: {
                config.action()
            }) {
                Text(config.text)
            }
            .disabled(config.isDisabled)
            .clipShape(Capsule())
            .buttonStyle(.borderedProminent)
        }
        else {
            Button(action: {
                config.action()
            }) {
                Text(config.text)
            }
            .disabled(config.isDisabled)
            .clipShape(Capsule())
            .buttonStyle(.bordered)
        }
        
       
#endif
        
#if os(macOS)
        Button(action: {
            config.action()
        }) {
            Text(config.text)
        }
        .disabled(config.isDisabled)
		  //.background(config.variant == .outline ? Color.secondary : Color.clear)
        .foregroundStyle(config.variant == .outline ? Color.primary : Color.clear)
#endif
        
    }
    
    init(text: String, action: @escaping () -> Void) {
        config = Config(text: text, action: action)
    }

    func variant(_ variant: oButtonVariants) -> oButton {
        var button = self
        button.config.variant = variant
        return button
    }

    func isDisabled(_ isDisabled: Bool) -> oButton {
        var button = self
        button.config.isDisabled = isDisabled
        return button
    }

    private struct Config {
        var text: String
        var action: () -> Void
        var isDisabled: Bool = false
        var variant: oButtonVariants = .fill
    }
}



