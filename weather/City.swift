//
//  City.swift
//  weather
//
//  Created by Baldoph Pourprix on 29/03/2016.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import UIKit

class City: NSObject, NSCoding {
    var name = "Lyon"
    var cityID = "6454573"
    var currentWeather: CurrentWeather?
    var daysForecasts: [DayForecast]?
    
    override init() {}
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        cityID = aDecoder.decodeObjectForKey("cityID") as! String
        currentWeather = aDecoder.decodeObjectForKey("currentWeather") as? CurrentWeather
        daysForecasts = aDecoder.decodeObjectForKey("daysForecasts") as? [DayForecast]
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(cityID, forKey: "cityID")
        aCoder.encodeObject(daysForecasts, forKey: "daysForecasts")
        aCoder.encodeObject(currentWeather, forKey: "currentWeather")
    }
}
