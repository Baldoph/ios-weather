//
//  WeatherNetwork.swift
//  weather
//
//  Created by Baldoph Pourprix on 04/04/16.
//  Copyright © 2016 Baldoph Pourprix. All rights reserved.
//

import Foundation
import RxSwift

public struct WeatherNetwork: WeatherService, Networking {
    
    public init(client: Client) {
        self.client = client
    }

    public let client: Client
    public let disposeBag = DisposeBag()

    public func requestForcastForCity(query: String) -> Observable<ForecastResponse> {
        return request(.GET, urlPath: "forecast/daily", parameters: ["q": query, "cnt": 8])
    }
    
    public func requestCurrentForCity(query: String) -> Observable<CurrentWeatherResponse> {
        return request(.GET, urlPath: "weather", parameters: ["q": query])
    }
}