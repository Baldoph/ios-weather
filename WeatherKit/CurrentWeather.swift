//
//  CurrentWeather.swift
//  weather
//
//  Created by Baldoph Pourprix on 04/04/16.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import Foundation
import Argo
import Curry

public enum WeatherInfoType {
    case Sunrise
    case Sunset
    case Clouds
    case Rain
    case Humidity
    case Pressure
    case Temperature
}

public struct CurrentWeather {
    public var weatherDescription: [WeatherDescription]
    public var temperature: Temperature
    public var cloudiness: Int
    public var rain: Int?
    public var pressure: Int
    public var humidity: Int
    public var sunrise: NSDate
    public var sunset: NSDate
}

extension CurrentWeather: Decodable {
    public static func decode(j: JSON) -> Decoded<CurrentWeather> {
        let a = curry(CurrentWeather.init)
            <^> j <|| "weather"
            <*> (j <| ["main", "temp"] >>- toTemperature)
            <*> j <| ["clouds", "all"]
            <*> j <|? ["rain", "3h"]
            <*> j <| ["main", "pressure"]
            <*> j <| ["main", "humidity"]
        
        return a
            <*> (j <| ["sys", "sunrise"] >>- toNSDate)
            <*> (j <| ["sys", "sunset"] >>- toNSDate)
    }
}

public struct WeatherDescription: Decodable {
    
    public let description: String
    
    public static func decode(j: Argo.JSON) -> Decoded<WeatherDescription> {
        
        return curry(WeatherDescription.init)
            <^> j <| ["description"]
    }
}

private let timeFormatter: NSDateFormatter = {
    let df = NSDateFormatter()
    df.timeStyle = .ShortStyle
    return df
}()

extension CurrentWeather {
    public func stringValueForWeatherInfoType(type: WeatherInfoType) -> String {
        var rValue: String! = nil
        switch type {
        case .Sunrise:
                rValue = timeFormatter.stringFromDate(sunrise)
        case .Sunset:
                rValue = timeFormatter.stringFromDate(sunset)
        case .Clouds:
                rValue = "\(cloudiness) %"
        case .Humidity:
                rValue = "\(humidity) %"
        case .Pressure:
                rValue = "\(pressure) hPa"
        case .Rain:
            if let rain = rain {
                rValue = "\(rain) mm"
            } else {
                rValue = "0 mm"
            }
        case .Temperature:
            rValue = temperature.toString()
        }
        return rValue
    }
    
    public static func descriptionForWeatherInfoType(type: WeatherInfoType) -> String {
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
