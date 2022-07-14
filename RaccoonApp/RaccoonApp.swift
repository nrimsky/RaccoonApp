//
//  RaccoonAppApp.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 14/07/2022.
//

import SwiftUI

@main
struct RaccoonApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AppState())
        }
    }
}
