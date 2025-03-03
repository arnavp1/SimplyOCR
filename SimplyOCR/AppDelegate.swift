//
//  AppDelegate.swift
//  SimplyOCR
//
//  Created by Arnav Podichetty on 3/2/25.
//

import Cocoa
import SwiftUI
import KeyboardShortcuts

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    
    lazy var settingsWC: NSWindowController = {
        let vc = NSHostingController(rootView: SettingsView())
        let w = NSWindow(contentViewController: vc)
        w.title = "Settings"
        let wc = NSWindowController(window: w)
        return wc
    }()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.title = "SimplyOCR"
        }
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit SimplyOCR", action: #selector(quitApp), keyEquivalent: "q"))
        statusItem?.menu = menu
        
        if KeyboardShortcuts.getShortcut(for: KeyboardShortcuts.Name.captureAndOCR) == nil {
            KeyboardShortcuts.setShortcut(.init(.s, modifiers: [.command, .shift]), for: KeyboardShortcuts.Name.captureAndOCR)
        }

        KeyboardShortcuts.onKeyDown(for: .captureAndOCR) {
            GlobalHotKeyManager.shared.captureAndOCR()
        }
        
    }
    
    @objc func openSettings() {
        settingsWC.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func quitApp() {
        NSApp.terminate(nil)
    }
}
