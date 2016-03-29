//
//  DayForecast.swift
//  weather
//
//  Created by Baldoph Pourprix on 29/03/2016.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import UIKit

class DayForecast: NSObject {
    var date: NSDate!
    var temperatureMin: Float!
    var temperatureMax: Float!
    var rainHeight: Float?
    
    required init(dictionary: NSDictionary) {
        date = NSDate(timeIntervalSince1970:
            NSTimeInterval( dictionary.valueForKeyPath("dt") as! Int ))
        temperatureMin = (dictionary.valueForKeyPath("temp.min") as! NSNumber).floatValue
        temperatureMax = (dictionary.valueForKeyPath("temp.max") as! NSNumber).floatValue
        rainHeight = (dictionary.valueForKeyPath("rain") as? NSNumber)?.floatValue
    }
    
    class func objectsFromJSON(JSON: NSDictionary) -> [DayForecast] {
        var results: [DayForecast] = []
        for dict in JSON["list"] as! [NSDictionary] {
            results.append(DayForecast(dictionary: dict))
        }
        return results
    }
}
