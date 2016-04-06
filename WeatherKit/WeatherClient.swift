//
//  WeatherClient.swift
//  weather
//
//  Created by Baldoph Pourprix on 04/04/16.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import Foundation
import ReachabilitySwift

public struct WeatherClient: Client {
    
    public init() {}
    
    public var reachability: Reachability? = try? Reachability.reachabilityForInternetConnection()
    
    public var baseURL: String {
        return "http://api.openweathermap.org/data/2.5"
    }
    
    public var baseParameters: [String : AnyObject]? {
        return ["appid" : "acf4afa1abdb42982de642934f090ad5",
        "units": "metric",
        "lang": NSLocalizedString("lang", comment: "")]
    }
}
