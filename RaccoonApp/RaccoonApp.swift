//
//  RaccoonApp.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 14/07/2022.
//

import SwiftUI

@main
struct RaccoonApp: App {
    @StateObject private var appState: AppState
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: Helpers.fontName, size: 24)!]
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: Helpers.fontName, size: UIFont.labelFontSize)!]
        
        // Initialize appState
        do {
            let loadedState = try AppState.load()
            _appState = StateObject(wrappedValue: loadedState)
        } catch {
            print("Failed to load AppState: \(error)")
            _appState = StateObject(wrappedValue: AppState())
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .errorAlert(error: $appState.currentError)
        }
    }
}
