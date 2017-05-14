//: [Previous](@previous)

import Foundation
import CoreImage
import UIKit

typealias Filter = (CIImage) -> CIImage

func blur(radius: Double) -> Filter {
    return {image in
        let parameters: [String: Any] = [kCIInputRadiusKey: radius,
                                         kCIInputImageKey: image]
        guard let filter = CIFilter(name: "CIGaussianBlur",
                                    withInputParameters: parameters)
            else { fatalError() }
        guard let outputImage = filter.outputImage
            else { fatalError() }
        return outputImage
    }
}

func generate(color: UIColor) -> Filter {
    return {image in
        let parameters: [String: Any] = [kCIInputColorKey: CIColor(cgColor: color.cgColor)]
        guard let filter = CIFilter(name: "CIConstantColorGenerator",
                                    withInputParameters: parameters)
            else { fatalError() }
        guard let outputImage = filter.outputImage
            else { fatalError() }
        return outputImage.cropping(to: image.extent)
    }
}

func compositeSourceOver(overlay: CIImage) -> Filter {
    return {image in
        let parameters = [kCIInputBackgroundImageKey: image,
                          kCIInputImageKey: overlay]
        guard let filter = CIFilter(name: "CISourceOverCompositing",
                                    withInputParameters: parameters)
            else { fatalError() }
        guard let outputImage = filter.outputImage
            else { fatalError() }
        return outputImage.cropping(to: image.extent)
    }
}

func overlay(color: UIColor) -> Filter {
    return {image in
        let overlay = generate(color: color)(image)
        return compositeSourceOver(overlay: overlay)(image)
    }
}

let url = URL(string: "http://www.objc.io/images/covers/16.jpg")!
let image = CIImage(contentsOf: url)!

let radius = 5.0
let color = UIColor.red.withAlphaComponent(0.2)
let blurredImage = blur(radius: radius)(image)
let overlaidImage = overlay(color: color)(image)

//Function composition

let result = overlay(color: color)(blur(radius: radius)(image))

func compose(filter filter1: @escaping Filter, with filter2: @escaping Filter) -> Filter {
    return { image in return filter2(filter1(image)) }
}

let blurAndOverlay = compose(filter: blur(radius: radius), with: overlay(color: color))
let result1 = blurAndOverlay(image)

precedencegroup CombiningPrecedence {
    associativity: left
}

infix operator >>>: CombiningPrecedence

func >>>(filter1: @escaping Filter, filter2: @escaping Filter) -> Filter {
    return { image in filter2(filter1(image)) }
}

let blurAndOverlay2 = blur(radius: radius) >>> overlay(color: color)
let result2 = blurAndOverlay2(image)

//: [Next](@next)
