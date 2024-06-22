//
//  ErrorAlertModifier.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 22/06/2024.
//

import SwiftUI

struct ErrorAlert: ViewModifier {
    @Binding var error: AppError?
    
    func body(content: Content) -> some View {
        content
            .alert(item: $error) { error in
                Alert(
                    title: Text("Error"),
                    message: Text(error.message),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
}

extension View {
    func errorAlert(error: Binding<AppError?>) -> some View {
        self.modifier(ErrorAlert(error: error))
    }
}
