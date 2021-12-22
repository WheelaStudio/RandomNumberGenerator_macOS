//
//  ContentView.swift
//  RandomNumberGenerator
//
//  Created by Serega on 10.12.2021.
//
import SwiftUI
struct MainView: View {
    @State private var result = ""
    @State private var deleteDescription = ""
    @State private var errorDescription = ""
    @State private var errorAlertIsShowed = false
    @State private var deleteAlertIsShowed = false
    @State private var selectedItems : Set<String> = []
    @State private var selection = 0
    @ObservedObject private var viewModel = MainViewModel()
    @ViewBuilder
    private func makeInputField(_ text: Binding<String>) -> some View
    {
        TextField("", text: text, prompt: nil)
    }
    var body: some View {
        TabView(selection: $selection) {
            VStack{
                HStack {
                    HStack(spacing: 3) {
                        Text(LocalizedStringKey("From"))
                        makeInputField($viewModel.from)
                    }
                    HStack(spacing: 3) {
                        Text(LocalizedStringKey("To"))
                        makeInputField($viewModel.to)
                    }
                }.padding(.top, 5).padding(.horizontal, 10)
                HStack {
                    Toggle(LocalizedStringKey("With step"), isOn: $viewModel.withStep)
                    makeInputField($viewModel.step).disabled(!viewModel.withStep)
                }.padding(.horizontal, 10)
                Button(action: {
                    viewModel.generateNumber {
                        error in
                        if let err = error {
                            errorDescription = err
                            errorAlertIsShowed = true
                        }
                    }
                }, label: {
                    Text(LocalizedStringKey("Generate"))
                })
                if let result = viewModel.result {
                    Text("\(NSLocalizedString("Result", comment: "")) \(result)").padding(.horizontal, 5).font(.system(.title2)).minimumScaleFactor(0.5).contextMenu {
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
            }.tag(0).tabItem {
                Text(LocalizedStringKey("Generation"))
            }.alert(errorDescription, isPresented: $errorAlertIsShowed) {
                Button("OK", role: .cancel) {}
            }
            VStack {
                if viewModel.history.isEmpty {
                    Text(LocalizedStringKey("HISTORY_IS_EMPTY")).font(.title2)
                } else {
                    List(selection: $selectedItems) {
                        ForEach(viewModel.history, id: \.self) {
                            element in
                            Text(element).contextMenu{
                                if selectedItems.count < 2 {
                                    Button(LocalizedStringKey("APPLY_TO_INTERFACE")) {
                                        viewModel.applyToInterface(element)
                                        selection = 0
                                    }
                                }
                            }
                        }
                    }.listStyle(.bordered(alternatesRowBackgrounds: true)).padding(.horizontal,2)
                    HStack {
                        Text(LocalizedStringKey("HISTORY_DESCRIPTION"))
                        Spacer()
                        Button(action: {
                            deleteDescription = selectedItems.count == 0 ? NSLocalizedString("DELETE_ALL", comment: "") : NSLocalizedString("DELETE_SELECTED", comment: "")
                            deleteAlertIsShowed = true
                        }, label: {
                            Image(systemName: "trash.fill")
                        })
                    }.padding(.horizontal)
                }
            }.alert(isPresented: $deleteAlertIsShowed){
                Alert(title: Text(deleteDescription), message: nil, primaryButton: .destructive(Text(LocalizedStringKey("YES")), action: {
                    if selectedItems.count != 0 {
                        viewModel.history = viewModel.history.filter{ !selectedItems.contains($0) }
                        selectedItems.removeAll()
                    } else {
                        viewModel.history.removeAll()
                    }
                }), secondaryButton: .cancel())
            }.tag(1).tabItem {
                Text(LocalizedStringKey("History"))
            }
        }.onAppear {
            viewModel.loadSettings()
        }
    }
}

