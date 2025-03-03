//
//  AppDelegate.swift
//  SimplyOCR
//
//  Created by Arnav Podichetty on 3/2/25.
//

import Cocoa
import SwiftUI
import KeyboardShortcuts
import UserNotifications

extension Notification.Name {
    static let settingsChanged = Notification.Name("settingsChanged")
}

class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
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
        
        // Set the notification delegate so that notifications appear even if the app is in the foreground
        UNUserNotificationCenter.current().delegate = self
        
        updateAppearance()
        NotificationCenter.default.addObserver(self, selector: #selector(settingsDidChange), name: .settingsChanged, object: nil)
        
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
    
    @objc func settingsDidChange() {
        updateAppearance()
    }
    
    func updateAppearance() {
        let defaults = UserDefaults.standard
        let showInDock = defaults.object(forKey: "showInDock") as? Bool ?? true
        let showInMenuBar = defaults.object(forKey: "showInMenuBar") as? Bool ?? true
        
        if showInDock {
            NSApp.setActivationPolicy(.regular)
        } else {
            NSApp.setActivationPolicy(.accessory)
        }
        
        if showInMenuBar {
            if statusItem == nil {
                statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
                if let button = statusItem?.button {
                    button.image = NSImage(systemSymbolName: "camera.viewfinder", accessibilityDescription: nil)
                }
                let menu = NSMenu()
                menu.addItem(NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ","))
                menu.addItem(.separator())
                menu.addItem(NSMenuItem(title: "Quit SimplyOCR", action: #selector(quitApp), keyEquivalent: "q"))
                statusItem?.menu = menu
            }
        } else {
            statusItem = nil
        }
    }
    
    // UNUserNotificationCenterDelegate method
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
