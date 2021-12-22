//
//  Model.swift
//  RandomNumberGenerator
//
//  Created by Serega on 10.12.2021.
//
public final class Model {
    public func generateNumber(min: Double, max : Double, step: Double?) -> Double
    {
        let from = min
        let to = max
        if let step = step {
            return (Double(Int.random(in: Int(from / step)...Int(to / step))) * step).clamped(min: from, max: to)
        }
        let maxDecPlaces = to.decimalPlaces
        let minDecPlaces = from.decimalPlaces
        return Double.random(in: from...to).rounded(toPlaces: maxDecPlaces > minDecPlaces ? maxDecPlaces : minDecPlaces)
    }
}
