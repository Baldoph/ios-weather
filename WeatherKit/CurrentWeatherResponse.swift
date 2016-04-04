//
//  CurrentWeatherResponse.swift
//  weather
//
//  Created by Baldoph Pourprix on 04/04/16.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import Foundation
import Argo
import Curry

public struct CurrentWeatherResponse {
    public let currentWeather: CurrentWeather
}

extension CurrentWeatherResponse: Decodable {
    
    public static func decode(j: Argo.JSON) -> Decoded<CurrentWeatherResponse> {
        return curry(CurrentWeatherResponse.init) <^> CurrentWeather.decode(j)
    }
}