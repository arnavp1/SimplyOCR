//
//  SimplyOCRApp.swift
//  SimplyOCR
//
//  Created by Arnav Podichetty on 3/2/25.
//

import SwiftUI

@main
struct SimplyOCRApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .fixedSize()
        }
        .windowResizability(.contentSize)
        Settings {
            SettingsView()
        }
    }
}
