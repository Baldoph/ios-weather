//
//  City.swift
//  weather
//
//  Created by Baldoph Pourprix on 01/04/16.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import Foundation

struct City {
    var name: String = "Lyon"
    var cityID: String = "6454573"
    var currentWeather: CurrentWeather!
    var forecasts: [DayForecast]!
}

