//
//  Model.swift
//  RandomNumberGenerator
//
//  Created by Serega on 10.12.2021.
//

import Foundation
public final class Model {
    public func generateNumber(min: Double, max : Double) -> Double
    {
            return Double.random(in: min...max)
    }
}
