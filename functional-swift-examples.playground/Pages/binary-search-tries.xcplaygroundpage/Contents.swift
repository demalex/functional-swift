//: [Previous](@previous)

import Foundation

indirect enum BinarySearchTree<Element: Comparable> {
  case leaf
  case node(BinarySearchTree<Element>, Element, BinarySearchTree<Element>)
}

extension BinarySearchTree {
  init() {
    self = .leaf
  }

  init(element: Element) {
    self = .node(.leaf, element, .leaf)
  }
}

var leaf = BinarySearchTree<Int>()
var five = BinarySearchTree<Int>(element: 5)
var nine = BinarySearchTree<Int>(element: 9)
var ten = BinarySearchTree<Int>.node(nine, 10, leaf)
var seven = BinarySearchTree<Int>.node(five, 7, ten)

extension BinarySearchTree {
  var count: Int {
    switch self {
    case .leaf:
      return 0
    case let .node(left, _, right):
      return 1 + left.count + right.count
    }
  }
}

let count = seven.count

extension BinarySearchTree {
  var elements: [Element] {
    switch self {
    case .leaf:
      return []
    case let .node(left, value, right):
      return left.elements + [value] + right.elements
    }
  }
}

let elements = seven.elements

extension BinarySearchTree {
  func reduce<T>(initial: T, _ combine: (T, Element, T) -> T) -> T {
    switch self {
    case .leaf:
      return initial
    case let .node(left, value, right):
      return combine(left.reduce(initial: initial, combine),
                     value,
                     right.reduce(initial: initial, combine))
    }
  }
}

extension BinarySearchTree {
  var elements_2: [Element] {
    return self.reduce(initial: []) { $0 + [$1] + $2 }
  }

  var count_2: Int {
    return self.reduce(initial: 0) { 1 + $0 + $2 }
  }
}

let elements_2 = seven.elements_2
let count_2 = seven.count_2

extension BinarySearchTree {
  var isEmpty: Bool {
    if case .leaf = self {
      return true
    } else {
      return false
    }
  }
}

let isSevenEmpty = seven.isEmpty
let isLeafEmpty = leaf.isEmpty

extension BinarySearchTree {
  var isBST: Bool {
    switch self {
    case .leaf:
      return true
    case let .node(left, x, right):
      return left.elements_2.all { y in y < x} && right.elements_2.all { y in y > x } && left.isBST && right.isBST
    }
  }
}

extension Sequence {
  func all(_ predicate: (Iterator.Element) -> Bool) -> Bool {
    for x in self where predicate(x) == false {
      return false
    }
    return true
  }
}

let isBST = seven.isBST

extension BinarySearchTree {
  func contains(_ element: Element) throws -> Bool {
    switch self {
    case .leaf:
      return false
    case let .node(_, x, _) where x == element:
      return true
    case let .node(left, x, _) where element < x:
      return try left.contains(element)
    case let .node(_, x, right) where element > x:
      return try right.contains(element)
    default: throw "Impossible option occured"
    }
  }
}

extension BinarySearchTree {
  func contains_2(_ element: Element) -> Bool {
    switch self {
    case .leaf:
      return false
    case let .node(left, x, right):
      if x == element {
        return true
      } else {
        return left.contains_2(element) ||
               right.contains_2(element)
      }
    }
  }
}

extension String: Error {}

let contains = try seven.contains(5)
let contains_2 = seven.contains_2(5)

extension BinarySearchTree {
  mutating func insert(_ element: Element) {
    switch self {
    case .leaf:
      self = BinarySearchTree(element: element)
    case .node(var left, let x, var right):
      if element < x {
        left.insert(element)
      } else if element > x {
        right.insert(element)
      }
      self = .node(left, x, right)
    }
  }
}

seven.insert(-4)
let elements12 = seven.elements_2
