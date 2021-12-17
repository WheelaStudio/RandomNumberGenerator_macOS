//
//  ViewModel.swift
//  RandomNumberGenerator
//
//  Created by Serega on 10.12.2021.
//
import SwiftUI
public final class MainViewModel : NSObject, ObservableObject
{
    private let HISTORY_KEY = "HISTORY_VALUE"
    private let STEP_KEY = "STEP_VALUE"
    private let WITH_STEP_KEY = "WITH_STEP_VALUE"
    private let FROM_KEY = "FROM_VALUE"
    private let TO_KEY = "TO_VALUE"
    private let RESULT_KEY = "RESULT_VALUE"
    private let MAX_INPUT = 38
    private(set) static var shared: MainViewModel!
    private(set) var result : Double?
    private let model = Model()
    public override init() {
        super.init()
        MainViewModel.shared = self
    }
    private func filter(newValue: String, ref: WritableKeyPath<MainViewModel, String>, haveMinus : Bool = true)
    {
        var result : String
        if (newValue.count > MAX_INPUT || newValue.lastIndexOf("-") > 0 || haveMinus ? newValue.count(of: ".") > 1 : false)
        {
            result = self[keyPath: ref]
        } else
        {
            result = newValue.filter { (haveMinus ? "-0123456789." : "0123456789.").contains($0) }
        }
        DispatchQueue.main.async { [weak self] in
            self?[keyPath: ref] = result
        }
    }
    @Published public var step = "" {
        willSet(newValue) {
            filter(newValue: newValue, ref: \MainViewModel.step, haveMinus: false)
        }
    }
    @Published public var withStep = false
    @Published public var from = "" {
        willSet(newValue) {
            filter(newValue: newValue, ref: \MainViewModel.from)
        }
    }
    @Published public var history : [String] = []
    @Published public var to = "" {
        willSet(newValue) {
            filter(newValue: newValue, ref: \MainViewModel.to)
        }
    }
    public func loadSettings()
    {
        let storage = UserDefaults.standard
        step = storage.string(forKey: STEP_KEY) ?? ""
        history = storage.stringArray(forKey: HISTORY_KEY) ?? []
        withStep = storage.bool(forKey: WITH_STEP_KEY)
        from = storage.string(forKey: FROM_KEY) ?? ""
        to = storage.string(forKey: TO_KEY) ?? ""
        result = Double(storage.string(forKey: RESULT_KEY) ?? "")
    }
    public func saveSettings()
    {
        let storage = UserDefaults.standard
        storage.set(step, forKey: STEP_KEY)
        storage.set(history, forKey: HISTORY_KEY)
        storage.set(withStep, forKey: WITH_STEP_KEY)
        storage.set(from, forKey: FROM_KEY)
        storage.set(to, forKey: TO_KEY)
        storage.set(result == nil ? "" : String(result!), forKey: RESULT_KEY)
    }
    public func generateNumber(completion: (String?) -> Void)
    {
        let min = Double(self.from)
        let max = Double(self.to)
        var errorDescription : String?
        if let min = min, let max = max  {
            let step = Double(step)
            if min > max {
                errorDescription = NSLocalizedString("NUM_GREATER_THAN_ANTOHER", comment: "")
            }
            else if withStep && (step != nil ? max - min < step! : true) {
                errorDescription = NSLocalizedString("STEP_ERROR", comment: "")
            }
            else
            {
                result = model.generateNumber(min: min, max: max, step: step)
            }
        }
        else {
            errorDescription = NSLocalizedString("Incorrect input", comment: "")
        }
        completion(errorDescription)
    }
}
