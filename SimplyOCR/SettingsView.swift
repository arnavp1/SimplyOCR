//
//  SettingsView.swift
//  SimplyOCR
//
//  Created by Arnav Podichetty on 3/2/25.
//

import SwiftUI
import KeyboardShortcuts

struct SettingsView: View {
    var body: some View {
        Form {
            HStack {
                Text("OCR Shortcut:")
                KeyboardShortcuts.Recorder(for: .captureAndOCR)
            }
        }
        .padding()
        .frame(width: 300, height: 100)
    }
}
