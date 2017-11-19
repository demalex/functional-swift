//: [Previous](@previous)

import Foundation

let cities = ["Paris" : 2241, "Madrid" : 3165, "Amsterdam" : 827, "Berlin" : 3562]

let madridPopulation: Int? = cities["Madrid"]

if madridPopulation != nil {
  print("Madrid population is \(madridPopulation! * 1000)")
} else {
  print("Unknown city madrid")
}

if let madridPopulation2: Int = cities["Madrid"] {
  print("Madrid population is \(madridPopulation2 * 1000)")
} else {
  print("Unknown city madrid")
}
infix operator ???

func ???<T>(optional: T?, defaultValue: @autoclosure () -> T) -> T {
  if let x = optional {
    return x
  } else {
    return defaultValue()
  }
}

let optional: Int? = nil
print(optional ??? 100)

// Optional chaining

struct Order {
  let orderNumber: Int
  let person: Person?
}

struct Person {
  let name: String
  let address: Address?
}

struct Address {
  let streetName: String
  let city: String
  let state: String?
}

let address = Address(streetName: "Turmstraße", city: "Berlin", state: "Moabit")
let person = Person(name: "Bob", address: address)
let order = Order(orderNumber: 10, person: person)

// Bad approach, could cause runtime exceptions

let state = order.person!.address!.state!

// Good approach, optional binding

if let myPerson = order.person,
  let myAddres = myPerson.address,
  let myState = myAddres.state {
  print(myState)
}

// Better approach, using optional chaining

if let myState = order.person?.address?.state {
  print(myState)
} else {
  print("Unknown person, address or state")
}

// Branching optionals

switch madridPopulation {
case 0?: print("Nobody in madrid")
case (1..<1000)?: print("Less than a million in madrid")
case .none: print("No data about Madrid")
case .some(let x): print("\(x) people in madrid")
}

// Guard

func populationDescriptionForCity(city: String) -> String? {
  guard let population = cities[city] else { return nil }
  return "The population of \(city) is \(population * 1000)"
}

let cityDescription = populationDescriptionForCity(city: "Madrid")
print(cityDescription as Any)

// Optional mapping

func incremental(optional: Int?) -> Int? {
  guard let x = optional else { return nil }
  return x + 1
}

func map<T, U>(optional: T?, transform: (T) -> U) -> U? {
  guard let x = optional else { return nil }
  return transform(x)
}

var incremental: Int? = 4
incremental = map(optional: incremental) { x in
  return x + 1
}

// Optional binding revisited

let x: Int? = 3
let y: Int? = nil
//let z: Int? = x + y It does not compile, cause mathematical addition only works on Int values rather tahn optional values

func addOptionals(optionalX: Int?, optionalY: Int?) -> Int? {
  if let x = optionalX {
    if let y = optionalY {
      return x + y
    }
  }
  return nil
}

// To reduce nesting, we can bind multiple optionals at the same time

func addOptionals2(optionalX: Int?, optionalY: Int?) -> Int? {
  if let x = optionalX,
    let y = optionalY {
    return x + y
  }
  return nil
}

// Even shorter using guard

func addOptionals3(optionalX: Int?, optionalY: Int?) -> Int? {
  guard let x = optionalX,
    let y = optionalY else { return nil }
  return x + y
}

let capitals = [
  "France": "Paris",
  "Spain": "Madrid",
  "The Netherlands": "Amsterdam",
  "Belgium": "Brussels"
]

func populationOfCapital(country: String) -> Int? {
  guard let capital = capitals[country],
    let population = cities[capital] else { return nil }
  return population * 1000
}

let population = populationOfCapital(country: "The Netherlands")
print(population as Any)

func flatMap<T, U>(optional: T?, _ transform: (T) -> U?) -> U? {
  guard let x = optional else { return nil }
  return transform(x)
}

func addOptionals4(optionalX: Int?, optionalY: Int?) -> Int? {
  return flatMap(optional: optionalX) { x in
    return flatMap(optional: optionalY) { y in
      return x + y
    }
  }
}

func populationOfCapital2(country: String) -> Int? {
  return flatMap(optional: capitals[country], { capital in
    return flatMap(optional: cities[capital], { population in
      return population * 1000
    })
  })
}

let population2 = populationOfCapital2(country: "Spain")
print(population2 as Any)

func populationOfCapital3(country: String) -> Int? {
  return capitals[country].flatMap({ capital in
    return cities[capital]
  }).flatMap({ population in
    return population * 1000
  })
}

let population3 = populationOfCapital3(country: "Spain")
print(population3 as Any)
