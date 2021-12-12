//
//  Model.swift
//  RandomNumberGenerator
//
//  Created by Serega on 10.12.2021.
//
public final class Model {
    public func generateNumber(min: Double, max : Double) -> Double
    {
        let minDecimalPlaces = min.decimalPlaces
        let maxDecimalPlaces = max.decimalPlaces
        return Double.random(in: min...max).rounded(toPlaces: maxDecimalPlaces > minDecimalPlaces ? maxDecimalPlaces : minDecimalPlaces)
    }
}
