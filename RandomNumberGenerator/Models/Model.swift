//
//  Model.swift
//  RandomNumberGenerator
//
//  Created by Serega on 10.12.2021.
//
public final class Model {
    private func numberOfMaxDecimalPlaces(_ array: [Double]) -> Int {
        var source = array
        source.sort { $0.decimalPlaces > $1.decimalPlaces }
        return source.first!.decimalPlaces
    }
    public func generateNumber(min: Double, max : Double, step: Double?) -> Double
    {
        var from = min
        var to = max
        if let step = step {
            from/=step
            to/=step
        }
        let decimalPlaces = numberOfMaxDecimalPlaces([min, max, step ?? 0])
        return (Double.random(in: from...to) * (step != nil ? step! : 1)).rounded(toPlaces: decimalPlaces)
    }
}
