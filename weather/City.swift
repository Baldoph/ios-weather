//
//  City.swift
//  weather
//
//  Created by Baldoph Pourprix on 29/03/2016.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import UIKit

class City: NSObject {
    var name = "Lyon"
    var cityID = "6454573"
    var currentWeather: CurrentWeather!
    var daysForecasts: [DayForecast]!
}
