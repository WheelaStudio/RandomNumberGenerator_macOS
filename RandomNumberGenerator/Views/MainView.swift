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
    @State private var selectedItems : Set<Int> = []
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
                        Text(LocalizedStringKey("FROM"))
                        makeInputField($viewModel.from)
                    }
                    HStack(spacing: 3) {
                        Text(LocalizedStringKey("TO"))
                        makeInputField($viewModel.to)
                    }
                }.padding(.top, 5).padding(.horizontal, 10)
                HStack {
                    let stepIsDisabled = !viewModel.stepIsAvailable
                    Toggle(LocalizedStringKey("WITH_STEP"), isOn: $viewModel.withStep).disabled(stepIsDisabled)
                    makeInputField($viewModel.step).disabled(!viewModel.withStep || stepIsDisabled)
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
                    Text(LocalizedStringKey("GENERATE"))
                })
                if let result = viewModel.result {
                    Text("\(NSLocalizedString("RESULT", comment: "")) \(result.formattedWithSeparator)").padding(.horizontal, 5).font(.system(.title2)).minimumScaleFactor(0.5).contextMenu {
                        Button(action: {
                            let pasteboard = NSPasteboard.general
                            pasteboard.declareTypes([.string], owner: nil)
                            pasteboard.setString(result.stringWithoutZeroFraction, forType: .string)
                        }, label: {
                            Text(LocalizedStringKey("COPY"))
                        })
                    }
                }
                Spacer()
            }.tag(0).tabItem {
                Text(LocalizedStringKey("GENERATION"))
            }.alert(errorDescription, isPresented: $errorAlertIsShowed) {
                Button("OK", role: .cancel) {}
            }
            VStack {
                if viewModel.history.isEmpty {
                    Text(LocalizedStringKey("HISTORY_IS_EMPTY")).font(.title2)
                } else {
                    List(selection: $selectedItems) {
                        ForEach(viewModel.history.indices, id: \.self) {
                            index in
                            Text(viewModel.history[index]).contextMenu{
                                if selectedItems.count == 1 {
                                    Button(LocalizedStringKey("APPLY_TO_INTERFACE")) {
                                        viewModel.applyToInterface(viewModel.history[index])
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
                        var selectedItems = Array<String>(repeating: "", count: selectedItems.count)
                        for i in 0..<selectedItems.count {
                            selectedItems[i] = viewModel.history[self.selectedItems[self.selectedItems.index(self.selectedItems.startIndex, offsetBy: i)]]
                        }
                        viewModel.history = viewModel.history.filter{ !selectedItems.contains($0)}
                        self.selectedItems.removeAll()
                    } else {
                        viewModel.history.removeAll()
                    }
                }), secondaryButton: .cancel())
            }.tag(1).tabItem {
                Text(LocalizedStringKey("HISTORY"))
            }
        }.onAppear {
            viewModel.loadSettings()
        }
    }
}

