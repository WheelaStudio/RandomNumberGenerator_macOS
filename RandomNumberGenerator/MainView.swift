//
//  ContentView.swift
//  RandomNumberGenerator
//
//  Created by Serega on 10.12.2021.
//

import SwiftUI
struct MainView: View {
    @State private var result = ""
    @State private var errorDescription = ""
    @State private var errorAlertIsShowed = false
    @ObservedObject private var viewModel = MainViewModel()
    @ViewBuilder
    private func makeInputField(_ title: LocalizedStringKey, text: Binding<String>) -> some View
    {
        TextField(title, text: text, prompt: nil)
    }
    private var trailingZeroResult : String {
        get {
            return viewModel.result == nil ? "" : viewModel.result!.forTrailingZero()
        }
    }
    var body: some View {
        VStack{
            HStack {
                makeInputField(LocalizedStringKey("From"), text: $viewModel.from)
                makeInputField(LocalizedStringKey("To"), text: $viewModel.to)
            }.padding(.top, 10).padding(.horizontal, 10)
            Button(LocalizedStringKey("Generate"), action: {
                viewModel.generateNumber {
                    error in
                    if let err = error {
                        errorDescription = err
                        errorAlertIsShowed = true
                    } else {
                        result = trailingZeroResult
                    }
                }
                viewModel.saveSettings()
            })
            if !result.isEmpty {
                Text(viewModel.result == nil ? "" : NSLocalizedString("Result", comment: "") + result).contextMenu {
                    Button(action: {
                        let pasteboard = NSPasteboard.general
                        pasteboard.declareTypes([.string], owner: nil)
                        pasteboard.setString(result, forType: .string)
                    }, label: {
                        Text(LocalizedStringKey("Copy"))
                    })
                }
            }
            Spacer()
        }.alert(errorDescription, isPresented: $errorAlertIsShowed) {
            Button("OK", role: .cancel) {}
        }.onAppear{
            viewModel.loadSettings()
            result = trailingZeroResult
        }
        
        
    }
}

