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

public struct CurrentWeather {
    var weatherDescription: [WeatherDescription]
    var temperature: Float
    var cloudiness: Int
    var rain: Int?
    var pressure: Int
    var humidity: Int
    var sunrise: NSDate
    var sunset: NSDate
}

extension CurrentWeather: Decodable {
    public static func decode(j: JSON) -> Decoded<CurrentWeather> {
        let a = curry(CurrentWeather.init)
            <^> j <|| "weather"
            <*> j <| ["main", "temp"]
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
