//
//  Extensions.swift
//  RandomNumberGenerator
//
//  Created by Serega on 10.12.2021.
//

import Foundation
extension Double {
    func forTrailingZero() -> String {
        let result = String(format: "%g", self)
        return result == "-0" ? "0" : result
    }
    var decimalPlaces: Int {
        let strDouble = String(self)
        let decimals = strDouble.contains(".") ? strDouble.split(separator: ".")[1] : "0"
        return decimals == "0" ? 0 : decimals.count
    }
    func rounded(toPlaces places:Int) -> Double {
           let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
       }
}
extension String {
   public func count(of needle: Character) -> Int {
           return reduce(0) {
               $1 == needle ? $0 + 1 : $0
           }
       }
    public func lastIndexOf(_ symbol: Character) -> Int
    {
        var lastIndex = -1
        let arr = Array(self)
        for i in 0..<arr.count {
            if(arr[i] as Character? == symbol)
            {
                 lastIndex = i
            }
        }
        return lastIndex
    }
}
