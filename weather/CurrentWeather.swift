//
//  CurrentWeather.swift
//  weather
//
//  Created by Baldoph Pourprix on 29/03/2016.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import UIKit

enum WeatherInfoType {
    case Sunrise
    case Sunset
    case Clouds
    case Rain
    case Humidity
    case Pressure
    case Temperature
    case Summary
}

private let timeFormatter = NSDateFormatter()

class CurrentWeather: NSObject, NSCoding {
    var weatherDescription: String?
    var temperature: NSNumber?
    var cloudiness: NSNumber?
    var rain: NSNumber?
    var pressure: NSNumber?
    var humidity: NSNumber?
    var sunrise: NSDate?
    var sunset: NSDate?
    
    override class func initialize() {
        super.initialize()
        timeFormatter.timeStyle = .ShortStyle
    }
    
    required init(dictionary: NSDictionary!) {
        weatherDescription = dictionary["weather"]![0]["description"] as? String
        temperature = dictionary.valueForKeyPath("main.temp") as? NSNumber
        cloudiness = dictionary.valueForKeyPath("clouds.all") as? NSNumber
        humidity = dictionary.valueForKeyPath("main.humidity") as? NSNumber
        pressure = dictionary.valueForKeyPath("main.pressure") as? NSNumber
        rain = dictionary.valueForKeyPath("rain.3h") as? NSNumber
        if let timestamp = dictionary.valueForKeyPath("sys.sunrise") as? Int {
            sunrise = NSDate(timeIntervalSince1970:NSTimeInterval(timestamp))
        }
        if let timestamp = dictionary.valueForKeyPath("sys.sunset") as? Int {
            sunset = NSDate(timeIntervalSince1970:NSTimeInterval(timestamp))
        }
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        weatherDescription = aDecoder.decodeObjectForKey("weatherDescription") as? String
        temperature = aDecoder.decodeObjectForKey("temperature") as? NSNumber
        cloudiness = aDecoder.decodeObjectForKey("cloudiness") as? NSNumber
        humidity = aDecoder.decodeObjectForKey("humidity") as? NSNumber
        pressure = aDecoder.decodeObjectForKey("pressure") as? NSNumber
        rain = aDecoder.decodeObjectForKey("rain") as? NSNumber
        sunrise = aDecoder.decodeObjectForKey("sunrise") as? NSDate
        sunset = aDecoder.decodeObjectForKey("sunset") as? NSDate
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {        
        aCoder.encodeObject(weatherDescription, forKey: "weatherDescription")
        aCoder.encodeObject(temperature, forKey: "temperature")
        aCoder.encodeObject(cloudiness, forKey: "cloudiness")
        aCoder.encodeObject(humidity, forKey: "humidity")
        aCoder.encodeObject(pressure, forKey: "pressure")
        aCoder.encodeObject(rain, forKey: "rain")
        aCoder.encodeObject(sunrise, forKey: "sunrise")
        aCoder.encodeObject(sunset, forKey: "sunset")
    }
}

extension CurrentWeather {
    func stringValueForWeatherInfoType(type: WeatherInfoType) -> String {
        var rValue: String! = nil
        switch type {
        case .Sunrise:
            if let sunrise = sunrise {
                rValue = timeFormatter.stringFromDate(sunrise)
            }
        case .Sunset:
            if let sunset = sunset {
                rValue = timeFormatter.stringFromDate(sunset)
            }
        case .Clouds:
            if let cloudiness = cloudiness {
                rValue = "\(Int(round(cloudiness.floatValue))) %"
            } else {
                rValue = "0 %"
            }
        case .Humidity:
            if let humidity = humidity {
                rValue = "\(Int(round(humidity.floatValue))) %"
            } else {
                rValue = "0 %"
            }
        case .Pressure:
            if let pressure = pressure {
                rValue = "\(Int(round(pressure.floatValue))) hPa"
            }
        case .Rain:
            if let rain = rain {
                rValue = "\(Int(round(rain.floatValue))) mm"
            } else {
                rValue = "0 mm"
            }
        case .Summary:
            if let summary = weatherDescription {
                rValue = summary
            }
        case .Temperature:
            if let temperature = temperature {
                rValue = "\(Int(round(temperature.floatValue)))°"
            } else {
                rValue = "--"
            }
        }
        
        if rValue == nil { rValue = "-" }
        return rValue
    }
    
    class func descriptionForWeatherInfoType(type: WeatherInfoType) -> String {
        switch type {
        case .Sunrise:
            return NSLocalizedString("Sunrise", comment: "Sunrise")
        case .Sunset:
            return NSLocalizedString("Sunset", comment: "Sunset")
        case .Clouds:
            return NSLocalizedString("Clouds", comment: "Clouds")
        case .Humidity:
            return NSLocalizedString("Humidity", comment: "Humidity")
        case .Pressure:
            return NSLocalizedString("Pressure", comment: "Pressure")
        case .Rain:
            return NSLocalizedString("Rain", comment: "Rain")
        default:
            return ""
        }
    }
}
