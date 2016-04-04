//
//  ForecastResponse.swift
//  weather
//
//  Created by Baldoph Pourprix on 04/04/16.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import Foundation
import Argo
import Curry

public struct ForecastResponse {
    public let city: City
    public let forecats: [DayForecast]
}

extension ForecastResponse: Decodable {
    
    public static func decode(j: Argo.JSON) -> Decoded<ForecastResponse> {
        return curry(ForecastResponse.init) <^> j <| "city" <*> j <|| "list"
    }
}
