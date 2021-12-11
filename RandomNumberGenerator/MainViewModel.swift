//
//  ViewModel.swift
//  RandomNumberGenerator
//
//  Created by Serega on 10.12.2021.
//

import Foundation
import SwiftUI
public final class MainViewModel : NSObject, ObservableObject
{
    private let FROM_KEY = "FROM_VALUE"
    private let TO_KEY = "TO_VALUE"
    private let RESULT_KEY = "RESULT_VALUE"
    private(set) var result : Double?
    private let model = Model()
    public func filter(newValue: String, ref: WritableKeyPath<MainViewModel, String>)
    {
        var result : String
        if(newValue.lastIndexOf("-") > 0 || newValue.count(of: ".") > 1)
        {
          result = self[keyPath: ref]
        } else
        {
            result = newValue.filter { "-0123456789.".contains($0) }
        }
        DispatchQueue.main.async { [weak self] in
            self?[keyPath: ref] = result
        }
    }
    @Published public var from = "" {
        willSet(newValue) {
            filter(newValue: newValue, ref: \MainViewModel.from)
        }
    }
    @Published public var to = "" {
        willSet(newValue) {
            filter(newValue: newValue, ref: \MainViewModel.to)
        }
    }
    public func loadSettings()
    {
        let storage = UserDefaults.standard
        from = storage.string(forKey: FROM_KEY) ?? ""
        to = storage.string(forKey: TO_KEY) ?? ""
        result = Double(storage.string(forKey: RESULT_KEY) ?? "")
    }
    public func saveSettings()
    {
        let storage = UserDefaults.standard
        storage.set(from, forKey: FROM_KEY)
        storage.set(to, forKey: TO_KEY)
        storage.set(result == nil ? "" : String(result!), forKey: RESULT_KEY)
    }
    public func generateNumber(completion: (String?) -> Void)
    {
        let min = Double(self.from)
        let max = Double(self.to)
        var errorDescription : String?
        if let min = min, let max = max {
            if min > max {
                errorDescription = NSLocalizedString("NUM_GREATER_THAN_ANTOHER", comment: "")
            } else
            {
                let minDecimalPlaces = min.decimalPlaces
                let maxDecimalPlaces = max.decimalPlaces
                result = model.generateNumber(min: min, max: max).rounded(toPlaces: maxDecimalPlaces > minDecimalPlaces ? maxDecimalPlaces : minDecimalPlaces)
            }
        }
        else {
            errorDescription = NSLocalizedString("Incorrect input", comment: "")
        }
        completion(errorDescription)
    }
}
