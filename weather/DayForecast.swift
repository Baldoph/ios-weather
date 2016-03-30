//
//  DayForecast.swift
//  weather
//
//  Created by Baldoph Pourprix on 29/03/2016.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import UIKit

class DayForecast: NSObject, NSCoding {
    var date: NSDate!
    var temperatureMin: NSNumber!
    var temperatureMax: NSNumber!
    
    required init(dictionary: NSDictionary) {
        date = NSDate(timeIntervalSince1970:
            NSTimeInterval( dictionary.valueForKeyPath("dt") as! Int ))
        temperatureMin = (dictionary.valueForKeyPath("temp.min") as! NSNumber)
        temperatureMax = (dictionary.valueForKeyPath("temp.max") as! NSNumber)
    }
    
    class func objectsFromJSON(JSON: NSDictionary) -> [DayForecast] {
        var results: [DayForecast] = []
        for dict in JSON["list"] as! [NSDictionary] {
            results.append(DayForecast(dictionary: dict))
        }
        return results
    }
    
    required init?(coder aDecoder: NSCoder) {
        date = aDecoder.decodeObjectForKey("date") as? NSDate
        temperatureMin = aDecoder.decodeObjectForKey("temperatureMin") as? NSNumber
        temperatureMax = aDecoder.decodeObjectForKey("temperatureMax") as? NSNumber
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeObject(temperatureMin, forKey: "temperatureMin")
        aCoder.encodeObject(temperatureMax, forKey: "temperatureMax")
    }

}
