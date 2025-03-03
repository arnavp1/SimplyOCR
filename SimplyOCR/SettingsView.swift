//
//  SettingsView.swift
//  SimplyOCR
//
//  Created by Arnav Podichetty on 3/2/25.
//

import SwiftUI
import KeyboardShortcuts

struct SettingsView: View {
    @AppStorage("showInDock") var showInDock: Bool = true
    @AppStorage("showInMenuBar") var showInMenuBar: Bool = true
    
    var body: some View {
        Form {
            HStack {
                Text("OCR Shortcut:")
                KeyboardShortcuts.Recorder(for: .captureAndOCR)
            }
            Toggle("Show in Dock", isOn: $showInDock)
                .onChange(of: showInDock) { _, _ in
                    NotificationCenter.default.post(name: .settingsChanged, object: nil)
                }
            Toggle("Show in Menu Bar", isOn: $showInMenuBar)
                .onChange(of: showInMenuBar) { _, _ in
                    NotificationCenter.default.post(name: .settingsChanged, object: nil)
                }
        }
        .padding()
        .frame(width: 300, height: 150)
    }
}
