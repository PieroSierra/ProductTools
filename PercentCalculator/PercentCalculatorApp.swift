//
//  PercentCalculatorApp.swift
//  PercentCalculator
//
//  Created by Piero Sierra on 31/08/2024.
//

import SwiftUI

@main
struct PercentCalculatorApp: App {
    // Register AppDelegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(WindowAccessor { window in
                    if let nsWindow = window {
                        delegate.configureWindow(nsWindow)
                    }
                })
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var mainWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Ensure window is configured correctly at launch
        if let window = NSApplication.shared.windows.first {
            configureWindow(window)
            window.title = "Percentage Calculator" // Set the title on the initial window
            window.delegate = self
            self.mainWindow = window
        }
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            // If no window is visible, create a new one
            createNewWindow()
        }
        return true
    }

    func createNewWindow() {
        let newWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 300),
            styleMask: [.titled, .closable],  // Do not include miniaturizable or resizable in new windows
            backing: .buffered,
            defer: false
        )

        newWindow.center()
        newWindow.title = "Percentage Calculator" // Set the title explicitly
        newWindow.contentView = NSHostingView(rootView: ContentView())
        configureWindow(newWindow)  // Apply the fixed size and no resizing
        newWindow.makeKeyAndOrderFront(nil)
        self.mainWindow = newWindow
    }

    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        // Ensure window can't be resized
        return NSSize(width: 500, height: 300)
    }

    // Apply window constraints and remove style masks
    func configureWindow(_ window: NSWindow) {
        window.setContentSize(NSSize(width: 500, height: 300))
        window.minSize = NSSize(width: 500, height: 300)
        window.maxSize = NSSize(width: 500, height: 300)
        window.styleMask.remove(.resizable)
        window.styleMask.remove(.miniaturizable) // Remove minimize button
        window.styleMask.remove(.fullScreen)     // Remove fullscreen button
        window.collectionBehavior = [.fullScreenNone]  // Disable fullscreen behavior
        window.delegate = self
    }
}

// Helper to Access NSWindow from SwiftUI
struct WindowAccessor: NSViewRepresentable {
    var callback: (NSWindow?) -> Void

    func makeNSView(context: Context) -> NSView {
        let nsView = NSView()
        DispatchQueue.main.async {
            if let window = nsView.window {
                self.callback(window)
            }
        }
        return nsView
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

// Translucent window style
struct TranslucentBackgroundView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.blendingMode = .behindWindow
        effectView.material = .hudWindow
        effectView.state = .active
        return effectView
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
