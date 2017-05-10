import UIKit

typealias Distance = Double

struct Position {
    var x: Double
    var y: Double
}

extension Position {
    func minus(p: Position) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }

    var length: Double {
        return sqrt(x * x + y * y)
    }
}

struct Ship {
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
}

extension Ship {
    func canSafelyEngageShip(target: Ship, friendly: Ship) -> Bool {
        let targetDistance = target.position.minus(p: position).length
        let fDistance = friendly.position.minus(p: target.position).length
        return targetDistance <= firingRange && targetDistance > unsafeRange && fDistance > unsafeRange
    }
}

let ship = Ship(position: Position(x: -2, y: 6), firingRange: 13, unsafeRange: 3)
let enemyShip = Ship(position: Position(x: 5, y: 5), firingRange: 7, unsafeRange: 1)
let friendlyShip = Ship(position: Position(x: 5, y: 1), firingRange: 5, unsafeRange: 1)

let canEngage = ship.canSafelyEngageShip(target: enemyShip, friendly: friendlyShip)

// Functional

typealias Region = (Position) -> Bool

func circle(radius: Distance) -> Region {
    return {point in point.length <= radius}
}

func shift(region: @escaping Region, offset: Position) -> Region {
    return {point in region(point.minus(p: offset))}
}

func invert(region: @escaping Region) -> Region {
    return {point in !region(point)}
}

func intersection(region1: @escaping Region, region2: @escaping Region) -> Region {
    return {point in region1(point) && region2(point)}
}

func union(region1: @escaping Region, region2: @escaping Region) -> Region {
    return {point in region1(point) || region2(point)}
}

func difference(region: @escaping Region, minus: @escaping Region) -> Region {
    return intersection(region1: region, region2: invert(region: minus))
}

extension Ship {
    func canSafelyEngageShipFunctional(target: Ship, friendly: Ship) -> Bool {
        let rangeRegion = difference(region: circle(radius: firingRange), minus: circle(radius: unsafeRange))
        let firingRegion = shift(region: rangeRegion, offset: position)
        let friendlyRegion = shift(region: circle(radius: unsafeRange), offset: friendly.position)
        let resultRegion = difference(region: firingRegion, minus: friendlyRegion)
        return resultRegion(target.position)
    }
}

let canEngageFunctionally = ship.canSafelyEngageShipFunctional(target: enemyShip, friendly: friendlyShip)
