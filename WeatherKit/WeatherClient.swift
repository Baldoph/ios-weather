//
//  WeatherClient.swift
//  weather
//
//  Created by Baldoph Pourprix on 04/04/16.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import Foundation

class WeatherClient: Client {
    
    var baseURL: String {
        return "http://api.openweathermap.org/data/2.5"
    }
    
    var baseParameters: [String : AnyObject]? {
        return ["appid" : "acf4afa1abdb42982de642934f090ad5",
        "units": "metric",
        "lang": NSLocalizedString("lang", comment: "")]
    }
}
