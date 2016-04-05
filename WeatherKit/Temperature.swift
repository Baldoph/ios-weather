//
//  Temperature.swift
//  weather
//
//  Created by Baldoph Pourprix on 04/04/16.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import Foundation
import Argo

public struct Temperature {
    public let value: Float
}

extension Temperature {
    
    public func toString() -> String {
        return "\(Int(round(value)))"
    }
}

extension Temperature: Decodable {
    public static func decode(j: JSON) -> Decoded<Temperature> {
        switch j {
        case let .Number(n): return pure(Temperature(value: n as Float))
        default: return .typeMismatch("Temperature", actual: j)
        }
    }
}