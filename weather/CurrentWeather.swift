//
//  CurrentWeather.swift
//  weather
//
//  Created by Baldoph Pourprix on 29/03/2016.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import UIKit

class CurrentWeather: NSObject {    
    var weatherDescription: String!
    var temperature: Float!
    var sunrise: NSDate!
    var sunset: NSDate!
    var cloudiness: Int!
    var rain: Int!
    var pressure: Int!
    
    required init(dictionary: NSDictionary!) {
        weatherDescription = dictionary.valueForKeyPath("weather.description") as! String
        temperature = Float(dictionary.valueForKeyPath("main.temp") as! String)!
        cloudiness = dictionary.valueForKeyPath("clouds.all") as! Int
        pressure = dictionary.valueForKeyPath("main.pressure") as! Int
        sunrise = NSDate(timeIntervalSince1970:
            NSTimeInterval( dictionary.valueForKeyPath("sys.sunrise") as! Int ))
        sunset = NSDate(timeIntervalSince1970:
            NSTimeInterval( dictionary.valueForKeyPath("sys.sunset") as! Int ))
        super.init()
    }
}
