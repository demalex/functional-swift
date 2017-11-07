//: [Previous](@previous)

import Foundation

//Map

func incrementArray(xs: [Int]) -> [Int] {
  var result: [Int] = []
  for x in xs {
    result.append(x + 1)
  }
  return result
}

let incrementedArray = incrementArray(xs: [1, 2, 3, 4, 5])

func doubleArray1(xs: [Int]) -> [Int] {
  var result: [Int] = []
  for x in xs {
    result.append(x * 2)
  }
  return result
}

let doubledArray1 = doubleArray1(xs: [1, 2, 3, 4, 5])

func computeIntArrays(xs: [Int], transform: (Int) -> Int) -> [Int] {
  var result: [Int] = []
  for x in xs {
    result.append(transform(x))
  }
  return result
}

func doubleArray2(xs: [Int]) -> [Int] {
  return computeIntArrays(xs: xs) { x in x * 2 }
}

let doubledArray2 = doubleArray2(xs: [1, 2, 3, 4, 5])

func computeBoolArrays(xs: [Int], transform: (Int) -> Bool) -> [Bool] {
  var result: [Bool] = []
  for x in xs {
    result.append(transform(x))
  }
  return result
}

func genericComputeArray<T>(xs: [Int], transform: (Int) -> T) -> [T] {
  var result: [T] = []
  for x in xs {
    result.append(transform(x))
  }
  return result
}

func map<Element, T>(xs: [Element], transform: (Element) -> T) -> [T] {
  var result: [T] = []
  for x in xs {
    result.append(transform(x))
  }
  return result
}

func genericComputeArray2<T>(xs: [Int], transform: (Int) -> T) -> [T] {
  return map(xs: xs, transform: transform)
}

func genericComputeArray3<T>(xs: [Int], transform: (Int) -> T) -> [T] {
  return xs.map(transform)
}

// Filter

let exampleFiles = ["README.md", "HelloWorld.swift", "Super.swift"]

func getSwiftFiles(files: [String]) -> [String] {
  var result: [String] = []
  for file in files {
    if file.hasSuffix(".swift") {
      result.append(file)
    }
  }
  return result
}

let swiftFiles = getSwiftFiles(files: exampleFiles)

func filter<Element>(xs: [Element], includeElement: (Element) -> Bool) -> [Element] {
  var result: [Element] = []
  for x in xs {
    if includeElement(x) {
      result.append(x)
    }
  }
  return result
}

let swiftFiles2 = filter(xs: exampleFiles) { file in file.hasSuffix(".swift") }

// Reduce

func sum(xs: [Int]) -> Int {
  var result: Int = 0
  for x in xs {
    result += x
  }
  return result
}

let sumResult = sum(xs: [1, 2, 3, 4])

func product(xs: [Int]) -> Int {
  var result: Int = 1
  for x in xs {
    result *= x
  }
  return result
}

let productResult = product(xs: [1, 2, 3, 4])

func concatenate(xs: [String]) -> String {
  var result: String = ""
  for x in xs {
    result += x
  }
  return result
}

let concatenateResult = concatenate(xs: ["A", "B", "C", "D"])

func prettyPrintArray(xs: [String]) -> String {
  var result: String = "Entries in the array xs:\n"
  for x in xs {
    result = " " + result + x + "\n"
  }
  return result
}

let prettyPrintArrayResult = prettyPrintArray(xs: ["A", "B", "C", "D"])

func reduce<Element, T>(xs: [Element], initial: T, combine: (T, Element) -> T) -> T {
  var result: T = initial
  for x in xs {
    result = combine(result, x)
  }
  return result
}

let reduceResult = reduce(xs: [1, 2, 3, 4], initial: "") { (initial, number) in initial + "\(number)" }

func sumUsingReduce(xs: [Int]) -> Int {
  return reduce(xs: xs, initial: 0, combine:+)
}

func productUsingReduce(xs: [Int]) -> Int {
  return reduce(xs: xs, initial: 0, combine:*)
}

func flattenUsingReduce<T>(xs: [[T]]) -> [T] {
  return reduce(xs: xs, initial: []) { initial, x in initial + x }
}

let flattenResult = flattenUsingReduce(xs: [[1, 3, 5], [7, 33], [24, 123]])

// Example

struct City {
  let name: String
  let population: Int
}

let paris = City(name: "Paris", population: 2241)
let madrid = City(name: "Madrid", population: 3165)
let amsterdam = City(name: "Amsterdam", population: 827)
let berlin = City(name: "Berlin", population: 3562)

let cities = [paris, madrid, amsterdam, berlin]

extension City {
  func cityByScalinPopulation() -> City {
    return City(name: name, population: population * 1000)
  }
}

cities.filter { $0.population > 1000 }
  .map { $0.cityByScalinPopulation() }
  .reduce("City : Population") { result, c in
    return result + "\n" + "\(c.name) : \(c.population)"
}

func curry<A,B,C>(f: @escaping (A, B) -> C) -> (A) -> ((B) -> C) {
  return { x in { y in return f(x, y) } }
}

let c = curry { (a: Int, b: Int) -> String in
  return "\(a)" + "\(b)"
}
