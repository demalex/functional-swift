//: [Previous](@previous)

import Foundation

//Value type

struct PointStruct {
  var x: Int
  var y: Int
}

var structPoint = PointStruct(x: 1, y: 2)
var sameStructPoint = structPoint
sameStructPoint.x = 3

//Reference type

class PointClass {
  var x: Int
  var y: Int

  init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }
}

var classPoint = PointClass(x: 1, y: 2)
var sameClassPoint = classPoint
sameClassPoint.x = 3



