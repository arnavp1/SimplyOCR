//
//  GlobalHotKeyManager.swift
//  SimplyOCR
//
//  Created by Arnav Podichetty on 3/2/25.
//

import SwiftUI
import Vision
import KeyboardShortcuts
import UserNotifications

extension KeyboardShortcuts.Name {
    static let captureAndOCR = Self("captureAndOCR")
}

class GlobalHotKeyManager: ObservableObject {
    static let shared = GlobalHotKeyManager()
    
    func captureAndOCR() {
        let task = Process()
        task.launchPath = "/usr/sbin/screencapture"
        task.arguments = ["-c", "-s", "-x"]
        task.launch()
        task.waitUntilExit()
        
        guard let data = NSPasteboard.general.data(forType: .tiff),
              let image = NSImage(data: data)
        else { return }
        
        performOCR(on: image)
    }
    
    private func performOCR(on image: NSImage) {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return }
        let request = VNRecognizeTextRequest { request, _ in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            let recognizedStrings = observations.compactMap { $0.topCandidates(1).first?.string }
            let fullText = recognizedStrings.joined(separator: "\n")
            DispatchQueue.main.async {
                let pb = NSPasteboard.general
                pb.clearContents()
                pb.setString(fullText, forType: .string)
                self.showNotification(with: fullText)
            }
        }
        request.recognitionLevel = .accurate
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
    
    private func showNotification(with text: String) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    let content = UNMutableNotificationContent()
                    content.title = "OCR Result Copied"
                    content.body = text.count > 100 ? String(text.prefix(100)) + "..." : text
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    center.add(request, withCompletionHandler: nil)
                }
            }
        }
    }
}
