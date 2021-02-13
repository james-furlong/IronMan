//
//  File.swift
//  
//
//  Created by James Furlong on 7/2/21.
//

import Foundation

// MARK: - Sum
// Usage: `let ageSum = users.sum(\.age)`
extension Sequence where Element: AdditiveArithmetic {
    /// Returns the total sum of all elements in the sequence
    func sum() -> Element { reduce(.zero, +) }
}

extension Sequence  {
    func sum<T: AdditiveArithmetic>(_ predicate: (Element) -> T) -> T {
        reduce(.zero) { $0 + predicate($1) }
    }
}

// MARK: - Average
// Usage:  `let ageAvg = users.average(\.age) `
extension Collection where Element: BinaryInteger {
    /// Returns the average of all elements in the array
    func average() -> Element { isEmpty ? .zero : sum() / Element(count) }
    /// Returns the average of all elements in the array as Floating Point type
    func average<T: FloatingPoint>() -> T { isEmpty ? .zero : T(sum()) / T(count) }
}

extension Collection where Element: BinaryFloatingPoint {
    /// Returns the average of all elements in the array
    func average() -> Element { isEmpty ? .zero : Element(sum()) / Element(count) }
}

extension Collection where Element == Decimal {
    func average() -> Decimal { isEmpty ? .zero : sum() / Decimal(count) }
}

extension Collection where Element == Double {
    func average() -> Double { isEmpty ? .zero : sum() / Double(count) }
}

extension Collection {
    func average<T: BinaryInteger>(_ predicate: (Element) -> T) -> T {
        sum(predicate) / T(count)
    }
    func average<T: BinaryInteger, F: BinaryFloatingPoint>(_ predicate: (Element) -> T) -> F {
        F(sum(predicate)) / F(count)
    }
    func average<T: BinaryFloatingPoint>(_ predicate: (Element) -> T) -> T {
        sum(predicate) / T(count)
    }
    func average(_ predicate: (Element) -> Decimal) -> Decimal {
        sum(predicate) / Decimal(count)
    }
}
