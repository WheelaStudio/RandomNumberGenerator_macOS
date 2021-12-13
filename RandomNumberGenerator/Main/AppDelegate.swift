//
//  AppDelegate.swift
//  RandomNumberGenerator
//
//  Created by Serega on 12.12.2021.
//
import AppKit
public final class AppDelegate: NSObject, NSApplicationDelegate {
    public func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        MainViewModel.shared.saveSettings()
        return true
    }
    public func applicationWillTerminate(_ notification: Notification) {
        MainViewModel.shared.saveSettings()
    }
    public func applicationDidFinishLaunching(_ notification: Notification) {
        for window in NSApp.windows {
            var style = window.styleMask
            style.remove(.resizable)
            window.styleMask = style
            window.standardWindowButton(.zoomButton)?.isHidden = true
        }
    }
    public func applicationWillFinishLaunching(_ notification: Notification) {
        NSWindow.allowsAutomaticWindowTabbing = false
    }
}
