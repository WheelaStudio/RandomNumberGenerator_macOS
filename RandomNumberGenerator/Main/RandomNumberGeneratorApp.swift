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
            MainView().frame(width: 300, height: 160)
        }.commands {
            CommandGroup(replacing: .newItem) {
            }
            CommandGroup(replacing: .help) {
            }
            CommandGroup(replacing: .systemServices) {
            }
        }
    }
}
