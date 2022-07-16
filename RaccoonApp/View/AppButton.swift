//
//  AppButton.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 16/07/2022.
//

import SwiftUI


enum AppButtonType {
    case destructive
    case normal
}

struct AppButton: View {
    
    let type: AppButtonType
    let onPress: () -> Void
    let text: String
    
    var body: some View {
        Button(action: onPress, label: {
            Text(text)
                .foregroundColor({
                    switch type {
                    case .destructive:
                        return .red
                    case .normal:
                        return .accentColor
                    }
                }())
        })
    }
}

