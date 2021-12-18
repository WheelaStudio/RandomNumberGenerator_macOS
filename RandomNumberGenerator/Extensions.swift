//
//  Extensions.swift
//  RandomNumberGenerator
//
//  Created by Serega on 10.12.2021.
//
extension Double {
    public func clamped(min: Double, max: Double) -> Double {
        if self < min {
            return min
        } else if self > max {
            return max
        }
        return self
    }
    public  var decimalPlaces: Int {
        let strDouble = String(self)
        let decimals = strDouble.contains(".") ? strDouble.split(separator: ".")[1] : "0"
        return decimals == "0" ? 0 : decimals.count
    }
    public func rounded(toPlaces places:Int) -> Double {
        let str = String(format: "%.\(places)f", self)
        return Double(str)!
    }
    public var stringWithoutZeroFraction: String {
        let str = truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
        return str == "-0" ? "0" : str
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
