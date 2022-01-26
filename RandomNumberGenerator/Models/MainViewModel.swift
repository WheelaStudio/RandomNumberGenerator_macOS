//
//  ViewModel.swift
//  RandomNumberGenerator
//
//  Created by Serega on 10.12.2021.
//
import SwiftUI
import Combine
public final class MainViewModel : ObservableObject
{
    private let HISTORY_KEY = "HISTORY_VALUE"
    private let STEP_KEY = "STEP_VALUE"
    private let WITH_STEP_KEY = "WITH_STEP_VALUE"
    private let FROM_KEY = "FROM_VALUE"
    private let TO_KEY = "TO_VALUE"
    private let RESULT_KEY = "RESULT_VALUE"
    private let MAX_INPUT = 38
    private(set) var stepIsAvailable = true
    private(set) static var shared: MainViewModel!
    private(set) var result : Double?
    private var fromCancellable : AnyCancellable?
    private var toCancellable : AnyCancellable?
    private var stepCancellable : AnyCancellable?
    private let model = Model()
    @Published public var step = ""
    @Published public var withStep = false
    @Published public var from = ""
    @Published public var history : [String] = []
    @Published public var to = ""
    public init() {
        MainViewModel.shared = self
        fromCancellable =  $from.sink {
            [self] newValue in
            filter(newValue: newValue, ref: \MainViewModel.from)
        }
        toCancellable =  $to.sink {
            [self] newValue in
            filter(newValue: newValue, ref: \MainViewModel.to)
        }
        stepCancellable =  $step.sink {
            [self] newValue in
            filter(newValue: newValue, ref: \MainViewModel.step, haveMinusAndDot: false)
        }
    }
    deinit {
        fromCancellable?.cancel()
        toCancellable?.cancel()
        stepCancellable?.cancel()
    }
    private func filter(newValue: String, ref: WritableKeyPath<MainViewModel, String>, haveMinusAndDot : Bool = true)
    {
        if newValue == self[keyPath: ref] {
            return
        }
        var result : String
        if (haveMinusAndDot && (newValue.count > MAX_INPUT || newValue.lastIndexOf("-") > 0 || newValue.count(of: ".") > 1))
        {
            result = self[keyPath: ref]
        } else
        {
            result = newValue.filter { (haveMinusAndDot ? "-0123456789." : "0123456789").contains($0) }
        }
        DispatchQueue.main.async { [weak self] in
            if var strongSelf = self {
                strongSelf[keyPath: ref] = result
                strongSelf.stepIsAvailable = Int(strongSelf.to) != nil && Int(strongSelf.from) != nil
            }
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
        self.result = storage.isKeyPresentInUserDefaults(key: RESULT_KEY) ? storage.double(forKey: RESULT_KEY) : nil
    }
    public func saveSettings()
    {
        let storage = UserDefaults.standard
        storage.set(step, forKey: STEP_KEY)
        storage.set(history, forKey: HISTORY_KEY)
        storage.set(withStep, forKey: WITH_STEP_KEY)
        storage.set(from, forKey: FROM_KEY)
        storage.set(to, forKey: TO_KEY)
        storage.set(result, forKey: RESULT_KEY)
    }
    public func applyToInterface(_ value: String) {
        let regex = try! NSRegularExpression(pattern: "[0-9]{1,}.[0-9]{1,}|[0-9]{1,}", options: [])
        let nsString = value as NSString
        let results = regex.matches(in: value, options: [], range: NSMakeRange(0, nsString.length))
        let numbers = results.map{nsString.substring(with: $0.range)}
        from = numbers[0]
        to = numbers[1]
        result = Double(numbers.last!)!
        if numbers.count == 4 {
            step = numbers[2]
            withStep = true
        } else {
            step = ""
            withStep = false
        }
    }
    public func generateNumber(completion: (String?) -> Void)
    {
        let min = Double(self.from)
        let max = Double(self.to)
        var errorDescription : String?
        if let min = min, let max = max  {
            let step = stepIsAvailable && withStep ? Double(step) : nil
            if min > max {
                errorDescription = NSLocalizedString("NUM_GREATER_THAN_ANTOHER", comment: "")
            }
            else if withStep && stepIsAvailable && (step != nil ? max - min < step! : true) {
                errorDescription = NSLocalizedString("STEP_ERROR", comment: "")
            }
            else
            {
                result = model.generateNumber(min: min, max: max, step: step)
                if history.count >= 100 {
                    history.remove(at: 0)
                }
                history.append("(\(from), \(to)\(step != nil ? ", \(step!.stringWithoutZeroFraction)"  : "")) = \(result!)")
            }
        }
        else {
            errorDescription = NSLocalizedString("Incorrect input", comment: "")
        }
        completion(errorDescription)
    }
}
