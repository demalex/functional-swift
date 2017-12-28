//: [Previous](@previous)

import Foundation
import CoreGraphics

func plusIsCommutative(x: Int, y: Int) -> Bool {
    return x + y == y + x
}

// Example of usage: check("Plus is commutative", plusIsCommutative)
// "Plus is commutative" passed 10 tests

// Generating arbitrary values for Int and String

protocol Smaller {
    func smaller() -> Self?
}

protocol Arbitrary: Smaller {
    static func arbitrary() -> Self
}

// Int

extension Int: Arbitrary {
    static func arbitrary() -> Int {
        return Int(arc4random())
    }
    
    func smaller() -> Int? {
        return self == 0 ? nil : self / 2
    }
}

extension Int {
    static func arbitrary(in range: CountableRange<Int>) -> Int {
        let diff = range.upperBound - range.lowerBound
        return range.lowerBound + (Int.arbitrary() % diff)
    }
}

// String

extension UnicodeScalar: Arbitrary {
    static func arbitrary() -> UnicodeScalar {
        return UnicodeScalar(Int.arbitrary(in: 65..<90))!
    }
    
    func smaller() -> UnicodeScalar? {
        return nil
    }
}

func tabulate<A>(times: Int, transform: (Int) -> A) -> [A] {
    return (0..<times).map(transform)
}

extension String: Arbitrary {
    static func arbitrary() -> String {
        let randomLength = Int.arbitrary(in: 0..<40)
        let randomCharacters = tabulate(times: randomLength) { _ in
            UnicodeScalar.arbitrary()
        }
        return String(UnicodeScalarView(randomCharacters))
    }
    
    func smaller() -> String? {
        return self.isEmpty ? nil : String(self.dropFirst())
    }
}

// Check function version one

let numberOfIterations = 10

func check1<A: Arbitrary>(message: String, _ property: (A) -> Bool) {
    for _ in 0..<numberOfIterations {
        let value = A.arbitrary()
        guard property(value) else {
            print("\"\(message)\" does not hold: \(value)")
            return
        }
    }
    print("\"\(message)\" passed \(numberOfIterations)")
}

// Example of usage

extension CGSize {
    var area: CGFloat {
        return self.height * self.width
    }
}

extension CGSize: Arbitrary {
    static func arbitrary() -> CGSize {
        return CGSize(width: Int.arbitrary(), height: Int.arbitrary())
    }
    
    func smaller() -> CGSize? {
        return self.equalTo(CGSize.zero) ? nil : CGSize.init(width: self.width / 2, height: self.height / 2)
    }
}

check1(message: "Area shoud not be less than zero") { (size: CGSize) in size.area >= 0 }

func iterateWhile<A>(condition: (A) -> Bool, initial: A, _ next: (A) -> A?) -> A {
    if let x = next(initial), condition(x) {
        iterateWhile(condition: condition, initial: x, next)
    }
    return initial
}

func check2<A: Arbitrary>(message: String, _ property: @escaping (A) -> Bool) {
    for _ in 0..<numberOfIterations {
        let value = A.arbitrary()
        print("Arbitrary value: \(value)")
        guard property(value) else {
            let smallerValue = iterateWhile(condition: { (x) -> Bool in
                return property(x) == false
            }, initial: value) { $0.smaller() }
            print("\"\(message)\" does not hold: \(smallerValue)")
            return
        }
    }
    print("\"\(message)\" passed \(numberOfIterations)")
}

// Arbitary arrays

func qsort(_ input: [Int]) -> [Int] {
    var array = input
    if array.isEmpty { return[] }
    let pivot = array.removeFirst()
    let lesser = array.filter { element in element < pivot }
    let greater = array.filter { element in element >= pivot }
    let intermediate = qsort(lesser) + [pivot]
    return intermediate + qsort(greater)
}

extension Array where Element: Arbitrary {
    static func arbitrary() -> [Element] {
        let randomLength = Int.arbitrary(in: 0..<50)
        return (0..<randomLength).map { _ in Element.arbitrary() }
    }
}

extension Array: Smaller {
    func smaller() -> [Element]? {
        guard self.isEmpty == false else {
            return nil
        }
        return Array(self.dropLast())
    }
}

//  check2(message: "qsort should behave like sort") { (x: [Int]) -> Bool in return qsort(x) == x.sorted() }
//  Expression above generates compiler error, because Array does not conform to Arbitrary protocol
//  Currently it is not possible to express restriction to Array like that:
//  extension Array: Arbitrary where Element: Arbitrary { ... }

struct ArbitraryInstance<T> {
    let arbitrary: () -> T
    let smaller: (T) -> T?
}

func checkHelper<A>(_ arbitraryInstance: ArbitraryInstance<A>, _ property: (A) -> Bool, _ message: String) {
    for _ in 0..<numberOfIterations {
        let value = arbitraryInstance.arbitrary()
        guard property(value) else {
            let smallerValue = iterateWhile(condition: { property($0) == false },
                                            initial: value,
                                            arbitraryInstance.smaller)
            print("\"\(message)\" does not hold: \(smallerValue)")
            return
        }
    }
    print("\"\(message)\" passed \(numberOfIterations)")
}

func check<A: Arbitrary>(_ message: String, _ property: @escaping (A) -> Bool) {
    let instance = ArbitraryInstance(arbitrary: A.arbitrary, smaller: { $0.smaller() })
    checkHelper(instance, property, message)
}

func check<A: Arbitrary>(_ message: String, _ property: @escaping ([A]) -> Bool) {
    let instance = ArbitraryInstance(arbitrary: Array.arbitrary, smaller: { (x: [A]) in x.smaller() })
    checkHelper(instance, property, message)
}

check("qsort should behave like sort") { (x: [Int]) -> Bool in return qsort(x) == x.sorted() }


