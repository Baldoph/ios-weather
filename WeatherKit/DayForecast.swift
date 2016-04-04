//
//  DayForecast.swift
//  weather
//
//  Created by Baldoph Pourprix on 04/04/16.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import Foundation
import Curry
import Argo

public struct DayForecast {
    public let temperatureMin: Float
    public let temperatureMax: Float
    public let date: NSDate
}

extension DayForecast: Decodable {
    public static func decode(j: JSON) -> Decoded<DayForecast> {
        return curry(DayForecast.init)
        <^> j <| ["temp", "min"]
        <*> j <| ["temp", "max"]
        <*> (j <| "date" >>- toNSDate)
    }
}