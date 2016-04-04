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

struct DayForecast {
    var temperatureMin: Float
    var temperatureMax: Float
    var date: NSDate
}

extension DayForecast: Decodable {
    static func decode(j: JSON) -> Decoded<DayForecast> {
        return curry(DayForecast.init)
        <^> j <| ["temp", "min"]
        <*> j <| ["temp", "max"]
        <*> (j <| "date" >>- toNSDate)
    }
}