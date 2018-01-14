//: [Previous](@previous)

import Foundation

// Genenric result

enum Result<T> {
  case success(T)
  case error(Error)
}

// Optional revisited

func ??<T>(result: Result<T>, handleError: (Error) -> T) -> T {
  switch result {
  case let .success(value):
    return value
  case let .error(error):
    return handleError(error)
  }
}

// The Algebra of Data Types

// The two types A and B are isomorphic if we can convert between them without loosing any information.
// In other words for all x: A the result of g(f(x)) equals x; similarly for all y: B the result of f(g(y)) equals y

enum Add<T, U> {
  case inLeft(T)
  case inRight(U)
}

enum Zero {}

typealias Times<T,U> = (T,U)

typealias One = ()
