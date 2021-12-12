//
//  AppDelegate.swift
//  RandomNumberGenerator
//
//  Created by Serega on 12.12.2021.
//
import AppKit
public class AppDelegate: NSObject, NSApplicationDelegate {
   public func applicationWillTerminate(_ aNotification: Notification) {
        MainViewModel.shared.saveSettings()
    }
}
