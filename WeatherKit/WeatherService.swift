//
//  Networking.swift
//  SampleWLSwiftNetworking
//
//  Created by Antoine Gamond on 22/02/2016.
//  Copyright © 2016 Worldline. All rights reserved.
//

import Foundation
import RxSwift
import Argo

public protocol WeatherService {

    func requestForcastForCity(query: String) -> Observable<ForecastResponse>
    func requestCurrentForCity(query: String) -> Observable<CurrentWeatherResponse>
}
