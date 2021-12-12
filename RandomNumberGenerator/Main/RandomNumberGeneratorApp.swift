//
//  RandomNumberGeneratorApp.swift
//  RandomNumberGenerator
//
//  Created by Serega on 10.12.2021.
//

import SwiftUI
@main
struct RandomNumberGeneratorApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            MainView().frame(width: 300, height: 95)
                .fixedSize()
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification), perform: { _ in
                    for window in NSApplication.shared.windows {
                        window.standardWindowButton(.zoomButton)?.isHidden = true
                    }
                })
        }
    }
}
