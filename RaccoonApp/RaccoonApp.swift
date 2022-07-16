//
//  RaccoonApp.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 14/07/2022.
//

import SwiftUI

@main
struct RaccoonApp: App {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: Helpers.fontName, size: 24)!]
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: Helpers.fontName, size: UIFont.labelFontSize)!]
    }
    
    var body: some Scene {
        if let state = try? AppState.load() {
            return WindowGroup {
                ContentView().environmentObject(state)
            }
        }
        return WindowGroup {
            ContentView().environmentObject(AppState())
        }
    }
}
